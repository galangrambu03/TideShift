from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import func, desc
from firebase_config import *
from auth_decorator import firebase_required
from datetime import date, timedelta
from models import DailyGoalsLog, db, User, DailyCarbonLog
from carbon import (
    EMISSION_FACTORS,
    CATEGORY_MAPPING,
    calculate_carbon_emissions,
    classify_level,
    get_emission_category,
    CarbonFuzzySystem,
    generate_improvement_suggestions
)
from datetime import date, datetime, timedelta

import pymysql
pymysql.install_as_MySQLdb()

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost/ecomagaradata?charset=utf8mb4'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

with app.app_context():
    db.create_all()

# ============================
# ROUTE: Sync User
# ============================
@app.route('/me', methods=['POST'])
@firebase_required
def sync_user():
    from firebase_admin import auth as fb_auth
    try:
        decoded = fb_auth.get_user(request.user_uid)
        email = decoded.email
        created_at = datetime.fromtimestamp(decoded.user_metadata.creation_timestamp / 1000.0)
    except Exception as e:
        return jsonify({"message": "Failed to retrieve user from Firebase", "error": str(e)}), 500

    data = request.get_json() or {}
    username = data.get('username') or email.split("@")[0]
    profile_url = data.get('profilePicture') or "assets/images/profilePictures/default.png"

    user = User.query.filter_by(firebase_uid=request.user_uid).first()
    if not user:
        user = User(
            firebase_uid=request.user_uid,
            email=email,
            username=username,
            profilePicture=profile_url,
            joinDate=created_at,
            points=0,
            currentIslandTheme=0
        )
        db.session.add(user)
        db.session.commit()
        return jsonify({"message": "New user saved to database"}), 201

    return jsonify({"message": "User already exists in database"}), 200

# ============================
# ROUTE: Get Profile
# ============================
@app.route('/me', methods=['GET'])
@firebase_required
def get_profile():
    user = User.query.filter_by(firebase_uid=request.user_uid).first()
    if not user:
        return jsonify({'message': 'User not found'}), 404

    return jsonify({
        "email": user.email,
        "username": user.username,
        "profilePicture": user.profilePicture,
        "joinDate": user.joinDate.isoformat(),
        "points": user.points,
        "currentIslandTheme": user.currentIslandTheme,
        "firebase_uid": user.firebase_uid
    }), 200

# ============================
# ROUTE: Leaderboard
# ============================
@app.route('/leaderboard', methods=['GET'])
@firebase_required
def leaderboard():
    entries = (
        db.session.query(
            User.username,
            func.sum(DailyCarbonLog.carbonSaved).label('totalPoints')
        )
        .join(DailyCarbonLog, DailyCarbonLog.usersId == User.id)
        .group_by(User.id)
        .order_by(desc('totalPoints'))
        .limit(10)
        .all()
    )

    leaderboard = [
        {"username": e.username, "points": int(e.totalPoints or 0)}
        for e in entries
    ]

    return jsonify({'leaderboard': leaderboard}), 200

# ============================
# ROUTE: Submit Checklist
# ============================
@app.route('/submit-checklist', methods=['POST'])
@firebase_required
def submit_checklist():
    payload = request.get_json() or {}
    user = User.query.filter_by(firebase_uid=request.user_uid).first()

    if not user:
        return jsonify({'message': 'User not found'}), 404

    total_kg = calculate_carbon_emissions(payload)
    level = classify_level(total_kg)

    thirty_days_ago = date.today() - timedelta(days=30)
    historical_logs = DailyCarbonLog.query.filter(
        DailyCarbonLog.usersId == user.id,
        DailyCarbonLog.logDate >= thirty_days_ago
    ).all()

    car_km = float(payload.get('carTravelKm', 0))
    shower_min = float(payload.get('showerTimeMinutes', 0))
    electronic_hours = float(payload.get('electronicTimeHours', 0))

    normal_values = CarbonFuzzySystem.calculate_normal_values(historical_logs)
    fuzzy_analysis = CarbonFuzzySystem.fuzzy_system_analysis(
        car_km, shower_min, electronic_hours, normal_values
    )

    improvement_suggestions = generate_improvement_suggestions(payload)

    # simpan log utama
    daily_log = DailyCarbonLog(
        usersId=user.id,
        totalCarbon=round(float(total_kg), 2),
        carbonLevel=level,
        IslandPath=level - 1,
        carbonSaved=int(payload.get("carbonSaved", 0)),
        logDate=date.today(),
        **{
            key: (1 if payload.get(key) is True else 0 if isinstance(payload.get(key), bool)
                  else int(payload.get(key) or 0))
            for key in EMISSION_FACTORS.keys()
        }
    )
    db.session.add(daily_log)

    # simpan goals (fuzzy dan improvement)
    goals_log = DailyGoalsLog(
        usersId=user.id,
        logDate=date.today(),
        # Numeric activities
        carTravelKmGoal=fuzzy_analysis['suggestions']['carTravelKm'],
        showerTimeMinutesGoal=fuzzy_analysis['suggestions']['showerTimeMinutes'],
        electronicTimeHoursGoal=fuzzy_analysis['suggestions']['electronicTimeHours'],
        # Negative checklist activities
        packagedFoodGoal=1 if 'packagedFood' in improvement_suggestions else 0,
        onlineShoppingGoal=1 if 'onlineShopping' in improvement_suggestions else 0,
        wasteFoodGoal=1 if 'wasteFood' in improvement_suggestions else 0,
        airConditioningHeatingGoal=1 if 'airConditioningHeating' in improvement_suggestions else 0,
        # Positive checklistactivities
        noDrivingGoal=1 if not 'noDriving' in improvement_suggestions else 0,
        plantMealThanMeatGoal=1 if not 'plantMealThanMeat' in improvement_suggestions else 0,
        useTumblerGoal=1 if not 'useTumbler' in improvement_suggestions else 0,
        saveEnergyGoal=1 if not 'saveEnergy' in improvement_suggestions else 0,
        separateRecycleWasteGoal=1 if not 'separateRecycleWaste' in improvement_suggestions else 0,

        suggestions=fuzzy_analysis['suggestions'],
        improvement_suggestions=improvement_suggestions
    )
    db.session.add(goals_log)

    db.session.commit()

    return jsonify({
        'totalcarbon': round(total_kg, 2),
        'carbonLevel': level,
        'emission_category': get_emission_category(level),
        'fuzzy_analysis': fuzzy_analysis,
        'improvement_suggestions': improvement_suggestions,
        'historical_data_points': len(historical_logs)
    }), 201


# ============================
# ROUTE: Fecth latest goals
# ============================
@app.route('/latest-goals', methods=['GET'])
@firebase_required
def get_latest_goals():
    user = User.query.filter_by(firebase_uid=request.user_uid).first()

    if not user:
        return jsonify({'message': 'User not found'}), 404

    latest_goals = DailyGoalsLog.query \
        .filter_by(usersId=user.id) \
        .order_by(DailyGoalsLog.logDate.desc()) \
        .first()

    if not latest_goals:
        return jsonify({'message': 'No goal log found'}), 404

    combined_goals = []

    # ===== Numeric Goals =====
    numeric_definitions = [
        {
            'field': 'carTravelKmGoal',
            'title': 'Try limit your vehicle usage to',
            'unit': 'km'
        },
        {
            'field': 'showerTimeMinutesGoal',
            'title': 'Try limit your showers time to',
            'unit': 'minutes'
        },
        {
            'field': 'electronicTimeHoursGoal',
            'title': 'Try reduce your screen time to',
            'unit': 'hours'
        }
    ]

    for item in numeric_definitions:
        value = getattr(latest_goals, item['field'])
        if value is not None:
            combined_goals.append({
                'type': 'numeric',
                'field': item['field'],
                'title': item['title'],
                'value': value,
                'unit': item['unit']
            })

    # ===== Negative Checklist Goals (if value == 0 → needs improvement) =====
    negative_fields = {
        'packagedFoodGoal': 'Eat unpackaged or fresh food',
        'onlineShoppingGoal': 'Limit online shopping habits',
        'wasteFoodGoal': 'Avoid food waste',
        'airConditioningHeatingGoal': 'Reduce air conditioning or heating usage'
    }

    for field, title in negative_fields.items():
        if getattr(latest_goals, field) == 0:
            combined_goals.append({
                'type': 'negative',
                'field': field,
                'title': title
            })

    # ===== Positive Checklist Goals (if value == 1 → encourage to start doing) =====
    positive_fields = {
        'noDrivingGoal': 'Use environmentally friendly transportation',
        'plantMealThanMeatGoal': 'Eat more plant based meals',
        'useTumblerGoal': 'Bring your own tumbler or reusable bottle',
        'saveEnergyGoal': 'Practice energy saving at home',
        'separateRecycleWasteGoal': 'Separate waste for recycling'
    }

    for field, title in positive_fields.items():
        if getattr(latest_goals, field) == 1:
            combined_goals.append({
                'type': 'positive',
                'field': field,
                'title': title
            })

    return jsonify({
        'goals': combined_goals,
        'logDate': latest_goals.logDate.isoformat()
    }), 200

# ============================
# ROUTE: Check Today's Submission
# ============================
@app.route('/check-today-submission', methods=['GET'])
@firebase_required
def check_today_submission():
    user = User.query.filter_by(firebase_uid=request.user_uid).first()

    if not user:
        return jsonify({'message': 'User not found'}), 404

    today = datetime.now().date()

    submission = DailyCarbonLog.query.filter(
        DailyCarbonLog.usersId == user.id,
        DailyCarbonLog.logDate == today
    ).first()

    has_submitted = submission is not None

    return jsonify({
        'user_id': user.id,
        'date_checked': str(today),
        'has_submitted': has_submitted,
        'message': 'User has already submitted today' if has_submitted else 'No submission found for today'
    }), 200


# ============================
# ROUTE: Get Daily Carbon Logs
# ============================
@app.route('/daily-carbon-logs', methods=['GET'])
@firebase_required
def get_all_daily_carbon_logs():
    try:
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        date_from = request.args.get('date_from')
        date_to = request.args.get('date_to')
        today_only = request.args.get('today_only', 'false').lower() == 'true'

        user = User.query.filter_by(firebase_uid=request.user_uid).first()
        if not user:
            return jsonify({"message": "User not found"}), 404

        query = DailyCarbonLog.query.filter(DailyCarbonLog.usersId == user.id)

        if today_only:
            today = date.today()
            query = query.filter(DailyCarbonLog.logDate == today)
        else:
            if date_from:
                date_from_obj = datetime.strptime(date_from, '%Y-%m-%d').date()
                query = query.filter(DailyCarbonLog.logDate >= date_from_obj)
            if date_to:
                date_to_obj = datetime.strptime(date_to, '%Y-%m-%d').date()
                query = query.filter(DailyCarbonLog.logDate <= date_to_obj)

        logs = query.order_by(desc(DailyCarbonLog.logDate)) \
                    .paginate(page=page, per_page=per_page, error_out=False)

        result = {
            "logs": [log.to_dict() for log in logs.items],
            "total_logs": logs.total,
            "current_page": logs.page,
            "per_page": logs.per_page,
            "total_pages": logs.pages
        }

        return jsonify(result), 200

    except Exception as e:
        return jsonify({
            "message": "Failed to retrieve logs",
            "error": str(e)
        }), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import func, desc
from firebase_config import *
from auth_decorator import firebase_required
from models import db, User, DailyCarbonLog
from carbon import (
    EMISSION_FACTORS,
    CATEGORY_MAPPING,
    calculate_carbon_emissions,
    classify_level,
    get_emission_category,
    CarbonFuzzySystem,
    generate_improvement_suggestions
)
from datetime import datetime, timedelta, timezone

# MySQL driver setup
import pymysql, os
pymysql.install_as_MySQLdb()

# Initialize the Flask application
app = Flask(__name__)

# Configure the database connection (MySQL using PyMySQL driver)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost/ecomagaradata?charset=utf8mb4'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Bind the app with SQLAlchemy instance
db.init_app(app)

# Create all tables (only run once when tables are not created yet)
with app.app_context():
    db.create_all() 


# 1. USER SERCTION

# ============================
# ROUTE: Sync User (First Login)
# ============================
@app.route('/me', methods=['POST'])
@firebase_required
def sync_user():
    from firebase_admin import auth as fb_auth
    from datetime import datetime, timezone

    try:
        # Get Firebase user info from UID in token
        decoded = fb_auth.get_user(request.user_uid)
        email = decoded.email
        created_at = datetime.fromtimestamp(
            decoded.user_metadata.creation_timestamp / 1000.0,
            tz=timezone.utc
        )
    except Exception as e:
        return jsonify({
            "message": "Failed to retrieve user from Firebase",
            "error": str(e)
        }), 500

    # Get extra data from frontend (Flutter)
    data = request.get_json() or {}
    username = data.get('username') or email.split("@")[0]
    profile_url = data.get('profilePicture') or "assets/images/profilePictures/default.png"

    # Check if user already exists
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
# ROUTE: Get Profile endpoint
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


# 2. LEADERBOARD FETURE SECTION    


# ============================
# ROUTE: Leaderboard Endpoint
# ============================
@app.route('/leaderboard', methods=['GET'])
@firebase_required  # Require authentication
def leaderboard():
    # Query top 10 users based on total carbonSaved points
    entries = (
        db.session.query(
            User.username,
            func.sum(DailyCarbonLog.carbonSaved).label('totalPoints')  # Calculate total saved carbon
        )
        .join(DailyCarbonLog, DailyCarbonLog.usersId == User.id)       # Join users with their logs
        .group_by(User.id)
        .order_by(desc('totalPoints'))                                  # Sort by highest points
        .limit(10)
        .all()
    )

    # Format the leaderboard output
    leaderboard = [
        {"username": e.username, "points": int(e.totalPoints or 0)}
        for e in entries
    ]

    return jsonify({'leaderboard': leaderboard}), 200




# 3. CHECKLIST FEATURE SECTION

# ========================================
# ROUTE: Submit Checklist with Fuzzy Analysis
# ========================================
@app.route('/submit-checklist', methods=['POST'])
@firebase_required
def submit_checklist():
    payload = request.get_json() or {}
    user = User.query.filter_by(firebase_uid=request.user_uid).first()

    if not user:
        return jsonify({'message': 'User not found'}), 404

    # Calculate total carbon emissions
    total_kg = calculate_carbon_emissions(payload)
    level = classify_level(total_kg)
    
    # Get historical data for fuzzy analysis (last 30 days)
    thirty_days_ago = datetime.now(timezone.utc) - timedelta(days=30)
    historical_logs = DailyCarbonLog.query.filter(
    DailyCarbonLog.usersId == user.id,
    DailyCarbonLog.logDate >= thirty_days_ago
    ).all()

    
    # Perform fuzzy analysis for main activities
    car_km = float(payload.get('carTravelKm', 0))
    shower_min = float(payload.get('showerTimeMinutes', 0))
    electronic_hours = float(payload.get('electronicTimeHours', 0))
    
    normal_values = CarbonFuzzySystem.calculate_normal_values(historical_logs)
    fuzzy_analysis = CarbonFuzzySystem.fuzzy_system_analysis(
        car_km, shower_min, electronic_hours, normal_values
    )
    
    # Generate improvement suggestions
    improvement_suggestions = generate_improvement_suggestions(payload)
    
    # Calculate potential savings from fuzzy suggestions
    current_main_emissions = (
        car_km * EMISSION_FACTORS['carTravelKm'] +
        shower_min * EMISSION_FACTORS['showerTimeMinutes'] +
        electronic_hours * EMISSION_FACTORS['electronicTimeHours']
    )
    
    suggested_emissions = (
        fuzzy_analysis['suggestions']['carTravelKm'] * EMISSION_FACTORS['carTravelKm'] +
        fuzzy_analysis['suggestions']['showerTimeMinutes'] * EMISSION_FACTORS['showerTimeMinutes'] +
        fuzzy_analysis['suggestions']['electronicTimeHours'] * EMISSION_FACTORS['electronicTimeHours']
    )
    
    potential_savings = max(0, current_main_emissions - suggested_emissions)

    log = DailyCarbonLog(
        usersId=user.id,
        totalCarbon=round(float(total_kg), 2),
        carbonLevel=level,
        IslandPath=level - 1,
        carbonSaved=int(payload.get("carbonSaved", 0)),
        logDate=datetime.now(timezone.utc),
        **{
            key: (1 if payload.get(key) is True else 0 if isinstance(payload.get(key), bool)
                else int(payload.get(key) or 0))
            for key in EMISSION_FACTORS.keys()
        }
    )

    db.session.add(log)
    db.session.commit()

    # Return comprehensive response
    return jsonify({
        'totalcarbon': round(total_kg, 2),
        'carbonLevel': level,
        'emission_category': get_emission_category(level),
        'fuzzy_analysis': {
            'suggestions': {
                'carTravelKm': round(fuzzy_analysis['suggestions']['carTravelKm'], 1),
                'showerTimeMinutes': round(fuzzy_analysis['suggestions']['showerTimeMinutes'], 1),
                'electronicTimeHours': round(fuzzy_analysis['suggestions']['electronicTimeHours'], 1)
            },
            'potential_savings': round(potential_savings, 2),
            'normal_values': {
                'carTravelKm': round(normal_values['carTravelKm'], 1),
                'showerTimeMinutes': round(normal_values['showerTimeMinutes'], 1),
                'electronicTimeHours': round(normal_values['electronicTimeHours'], 1)
            },
            'intensity_levels': {
                'carTravelKm': 'high' if fuzzy_analysis['membership_degrees']['carTravelKm'] > 0.3 
                              else 'moderate' if fuzzy_analysis['membership_degrees']['carTravelKm'] > 0.1 
                              else 'none',
                'showerTimeMinutes': 'high' if fuzzy_analysis['membership_degrees']['showerTimeMinutes'] > 0.3 
                                    else 'moderate' if fuzzy_analysis['membership_degrees']['showerTimeMinutes'] > 0.1 
                                    else 'none',
                'electronicTimeHours': 'high' if fuzzy_analysis['membership_degrees']['electronicTimeHours'] > 0.3 
                                      else 'moderate' if fuzzy_analysis['membership_degrees']['electronicTimeHours'] > 0.1 
                                      else 'none'
            }
        },
        'improvement_suggestions': improvement_suggestions,
        'historical_data_points': len(historical_logs)
    }), 201


# ============================
# ROUTE: Check Today's Submission
# ============================
@app.route('/check-today-submission', methods=['GET'])
@firebase_required  # Require authentication
def check_today_submission():
    user = User.query.filter_by(firebase_uid=request.user_uid).first()
    
    if not user:
        return jsonify({'message': 'User  not found'}), 404

    today = datetime.now(timezone.utc).date()

    # Query to check if there's a log for today
    submission = DailyCarbonLog.query.filter(
        DailyCarbonLog.usersId == user.id,
        DailyCarbonLog.logDate >= today
    ).first()

    has_submitted = submission is not None

    return jsonify({
        'user_id': user.id,
        'date_checked': str(today),
        'has_submitted': has_submitted,
        'message': 'User  has already submitted today' if has_submitted else 'No submission found for today'
    }), 200


# ============================
# ROUTE: Get daily carbon logs data
# ============================
@app.route('/daily-carbon-logs', methods=['GET'])
@firebase_required
def get_all_daily_carbon_logs():
    try:
        # Query parameters
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        user_id = request.args.get('user_id', type=int)
        date_from = request.args.get('date_from')
        date_to = request.args.get('date_to')
        today_only = request.args.get('today_only', 'false').lower() == 'true'

        # Base query
        query = DailyCarbonLog.query

        if user_id:
            query = query.filter(DailyCarbonLog.usersId == user_id)

        if today_only:
            today = datetime.now(timezone.utc).date()
            query = query.filter(DailyCarbonLog.logDate == today)
        else:
            if date_from:
                try:
                    date_from_obj = datetime.strptime(date_from, '%Y-%m-%d').date()
                    query = query.filter(DailyCarbonLog.logDate >= date_from_obj)
                except ValueError:
                    return jsonify({"message": "Invalid date_from format (use YYYY-MM-DD)"}), 400

            if date_to:
                try:
                    date_to_obj = datetime.strptime(date_to, '%Y-%m-%d').date()
                    query = query.filter(DailyCarbonLog.logDate <= date_to_obj)
                except ValueError:
                    return jsonify({"message": "Invalid date_to format (use YYYY-MM-DD)"}), 400

        # Sort & paginate
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


# =========================================
# Run the Flask app in development mode
# =========================================
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)


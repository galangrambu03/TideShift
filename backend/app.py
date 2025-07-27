from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import func, desc
from firebase_config import *                     # Firebase initialization config
from auth_decorator import firebase_required      # Custom decorator to require Firebase auth
from models import db, User, DailyCarbonLog       # Database models
from carbon import (                              # Functions and constants related to carbon calculation
    EMISSION_FACTORS,
    CATEGORY_MAPPING,
    calculate_carbon_emissions,
    classify_level
)

# MySQL driver setup
import pymysql, os
pymysql.install_as_MySQLdb()

# Initialize the Flask application
app = Flask(__name__)

# Configure the database connection (MySQL using PyMySQL driver)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost/ecomagara?charset=utf8mb4'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Bind the app with SQLAlchemy instance
db.init_app(app)

# Create all tables (only run once when tables are not created yet)
with app.app_context():
    db.create_all() 

# ========================================
# ROUTE: Submit Checklist (Carbon Logging)
# ========================================
@app.route('/submit-checklist', methods=['POST'])
@firebase_required  # Require valid Firebase user
def submit_checklist():
    payload = request.get_json() or {}  # Get the JSON data from request
    user = User.query.filter_by(firebase_uid=request.user_uid).first()  # Find user in DB

    if not user:
        return jsonify({'message': 'User not found'}), 404

    # Calculate total carbon emissions from the payload
    total_kg = calculate_carbon_emissions(payload)

    # Classify user's carbon footprint level
    level = classify_level(total_kg)

    # Create a new carbon log record
    log = DailyCarbonLog(
        usersId=user.id,
        totalCarbon=int(round(total_kg)),            # Total emissions rounded
        carbonLevel=level,                           # Emission level
        carbonSaved=int(payload.get("carbonSaved", 0)),  # Optional saved value

        # For each emission category, get the submitted value or default
        **{
            key: (1 if payload.get(key) is True else 0 if isinstance(payload.get(key), bool)
                  else int(payload.get(key) or 0))
            for key in EMISSION_FACTORS.keys()
        }
    )

    # Save the log into the database
    db.session.add(log)
    db.session.commit()

    # Return the total emissions and level back to client
    return jsonify({'totalcarbon': round(total_kg, 2), 'carbonLevel': level}), 201

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

# =========================================
# Run the Flask app in development mode
# =========================================
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)


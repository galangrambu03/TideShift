from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import func

db = SQLAlchemy()

# USER  
class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String(255), nullable=False, unique=True)
    username = db.Column(db.String(255), nullable=True)
    profilePicture = db.Column(db.String(100), nullable=True)
    joinDate = db.Column(db.DateTime, nullable=False)  
    points = db.Column(db.Integer, nullable=False, default=0)
    currentIslandTheme = db.Column(db.Integer, nullable=False, default=0)
    firebase_uid = db.Column(db.String(255), nullable=True, unique=True)


class DailyCarbonLog(db.Model):
    __tablename__ = 'dailycarbonlogs'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    usersId = db.Column(db.Integer, db.ForeignKey('users.id'))
    totalCarbon = db.Column(db.Integer)
    carbonLevel = db.Column(db.Integer)
    carbonSaved = db.Column(db.Integer)
    carTravelKm = db.Column(db.Integer)
    packagedFood = db.Column(db.Boolean)
    showerTimeMinutes = db.Column(db.Integer)
    electronicTimeHours = db.Column(db.Integer)
    onlineShopping = db.Column(db.Boolean)
    wasteFood = db.Column(db.Boolean)
    airConditioningHeating = db.Column(db.Boolean)
    noDriving = db.Column(db.Boolean)
    plantMealThanMeat = db.Column(db.Boolean)
    useTumbler = db.Column(db.Boolean)
    saveEnergy = db.Column(db.Boolean)
    separateRecycleWaste = db.Column(db.Boolean)
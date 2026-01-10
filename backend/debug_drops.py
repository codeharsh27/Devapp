
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models import Drop, Base

SQLALCHEMY_DATABASE_URL = "sqlite:///./devapp.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

db = SessionLocal()
drops = db.query(Drop).all()

for drop in drops:
    print(f"ID: {drop.id}")
    print(f"Title: {drop.title} (Type: {type(drop.title)})")
    print(f"Description: {drop.description} (Type: {type(drop.description)})")
    print(f"Domain: {drop.domain} (Type: {type(drop.domain)})")
    print(f"Difficulty: {drop.difficulty} (Type: {type(drop.difficulty)})")
    print("-" * 20)

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.core.config import settings
# 1. Create the Engine
# This opens the actual network socket to PostgreSQL.
engine = create_engine(settings.DATABASE_URL)
# 2. Create the SessionLocal class
# Each HTTP request gets its own "Session". 
# It's like a private sandbox to make changes.
# If the request fails, we throw away the sandbox (rollback).
# If the request succeeds, we commit the sandbox to the real DB.
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
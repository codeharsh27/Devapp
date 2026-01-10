from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, DateTime, Text, Enum, JSON
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum
from .database import Base

class DifficultyLevel(str, enum.Enum):
    EASY = "easy"
    MEDIUM = "medium"
    HARD = "hard"

class SubmissionStatus(str, enum.Enum):
    PENDING = "pending"
    EVALUATING = "evaluating"
    COMPLETED = "completed"
    FAILED = "failed"

class User(Base):
    __tablename__ = "users"

    # Supabase uses UUIDs (Strings)
    id = Column(String, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    # No hashed_password; we trust Supabase's JWT.
    
    # Store domains as comma-separated string for now, or use Array in Postgres
    domains = Column(String, nullable=True) 

    # Gamification Stats
    total_xp = Column(Integer, default=0)
    level = Column(Integer, default=1)
    current_streak = Column(Integer, default=0)
    
    # JSON breakdown: {"design": 100, "code": 500, "product": 0}
    xp_breakdown = Column(JSON, default=dict)
    
    submissions = relationship("Submission", back_populates="owner")

class SubmissionType(str, enum.Enum):
    CODE = "code"   # GitHub Repo
    LINK = "link"   # Figma, Website, Google Doc
    IMAGE = "image" # Screenshot, Design export
    FILE = "file"   # PDF, Zip (future)

class Drop(Base):
    __tablename__ = "drops"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(Text)
    domain = Column(String) # e.g., "backend", "frontend"
    difficulty = Column(Enum(DifficultyLevel, name="difficulty_level"), default=DifficultyLevel.EASY)
    submission_type = Column(Enum(SubmissionType, name="submission_type"), default=SubmissionType.CODE)
    
    time_limit_minutes = Column(Integer, default=60)
    reward_xp = Column(Integer, default=100)
    
    inputs_url = Column(String, nullable=True) # URL to resource/problem file
    source_url = Column(String, nullable=True) # Link to external source (e.g. GitHub issue)
    source_type = Column(String, default="A") # "A" for Internal, "B" for GitHub
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    submissions = relationship("Submission", back_populates="drop")

class Submission(Base):
    __tablename__ = "submissions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    drop_id = Column(Integer, ForeignKey("drops.id"))
    
    submission_url = Column(String) # GitHub link or file path
    doc_url = Column(String, nullable=True) # Documentation link
    image_url = Column(String, nullable=True) # Screenshot/Image link
    status = Column(Enum(SubmissionStatus, name="submission_status"), default=SubmissionStatus.PENDING)
    score = Column(Integer, nullable=True)
    feedback = Column(Text, nullable=True)
    
    submitted_at = Column(DateTime(timezone=True), server_default=func.now())
    completed_at = Column(DateTime(timezone=True), nullable=True)

    owner = relationship("User", back_populates="submissions")
    drop = relationship("Drop", back_populates="submissions")

from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, DateTime, Text, Enum, JSON, Numeric
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum
import uuid

from app.core.database import Base

class DifficultyLevel(str, enum.Enum):
    EASY = "easy"
    MEDIUM = "medium"
    HARD = "hard"

class SubmissionStatus(str, enum.Enum):
    ENROLLED = "enrolled"
    PENDING = "pending"
    PROCESSING = "processing"
    EVALUATED = "evaluated"
    FAILED = "failed"
    HIRED = "hired"

class User(Base):
    __tablename__ = "profiles"

    id = Column(String, primary_key=True)
    email = Column(String, unique=True, index=True)
    full_name = Column(String, nullable=True)
    avatar_url = Column(String, nullable=True)
    role = Column(String, nullable=True)
    bio = Column(Text, nullable=True)
    skills = Column(JSON, default=list)

    reputation_score = Column(Integer, default=100)
    wallet_balance = Column(Numeric(10, 2), default=0.00)

    # Startup Profile Fields
    website = Column(String, nullable=True)
    location = Column(String, nullable=True)
    industry = Column(String, nullable=True)
    team_size = Column(String, nullable=True)

    # Developer Financials
    upi_id = Column(String, nullable=True)

    # Gamification Stats
    total_xp = Column(Integer, default=0)
    level = Column(Integer, default=1)
    current_streak = Column(Integer, default=0)
    xp_breakdown = Column(JSON, default=dict)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    deleted_at = Column(DateTime(timezone=True), nullable=True)

    tasks = relationship("Task", back_populates="startup")
    submissions = relationship("Submission", back_populates="developer")
    experiences = relationship("Experience", back_populates="user")


class StartupProfile(Base):
    __tablename__ = "startup_profiles"
    user_id = Column(String, ForeignKey("profiles.id", ondelete="CASCADE"), primary_key=True)
    company_name = Column(String, nullable=True)
    industry = Column(String, nullable=True)
    verified = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    deleted_at = Column(DateTime(timezone=True), nullable=True)
    user = relationship("User", backref="startup_profile")

class TalentProfile(Base):
    __tablename__ = "talent_profiles"
    user_id = Column(String, ForeignKey("profiles.id", ondelete="CASCADE"), primary_key=True)
    xp_score = Column(Integer, default=0)
    level = Column(Integer, default=1)
    github_url = Column(String, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    deleted_at = Column(DateTime(timezone=True), nullable=True)
    user = relationship("User", backref="talent_profile")

class TaskStatus(str, enum.Enum):
    OPEN = "open"
    IN_PROGRESS = "in_progress"
    REVIEW = "review"
    COMPLETED = "completed"
    CANCELLED = "cancelled"

class Task(Base):
    __tablename__ = "tasks"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    startup_id = Column(String, ForeignKey("profiles.id", ondelete="CASCADE"), nullable=False)
    
    title = Column(String, nullable=False)
    description = Column(Text, nullable=False)
    bounty_amount = Column(Numeric(10, 2), default=0.00)
    category = Column(String)
    difficulty_level = Column(Integer)
    estimated_hours = Column(Integer, nullable=True)
    status = Column(Enum(TaskStatus, name="task_status_enum", create_type=False), default=TaskStatus.OPEN)
    repo_url = Column(String, nullable=True)
    requirements = Column(JSON, default=list)
    is_promoted = Column(Boolean, default=False)
    
    deadline = Column(DateTime(timezone=True), nullable=True)
    max_submissions = Column(Integer, nullable=True)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    deleted_at = Column(DateTime(timezone=True), nullable=True)

    startup = relationship("User", back_populates="tasks")
    submissions = relationship("Submission", back_populates="task", cascade="all, delete-orphan")
    criteria = relationship("TaskCriteria", back_populates="task", cascade="all, delete-orphan")


class TaskCriteria(Base):
    __tablename__ = "task_criteria"
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    task_id = Column(String, ForeignKey("tasks.id", ondelete="CASCADE"))
    type = Column(String)
    weight = Column(Numeric(5, 2))
    description = Column(Text)
    test_file_path = Column(String, nullable=True)
    
    task = relationship("Task", back_populates="criteria")


class Submission(Base):
    __tablename__ = "submissions"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    task_id = Column(String, ForeignKey("tasks.id", ondelete="CASCADE"))
    developer_id = Column(String, ForeignKey("profiles.id", ondelete="CASCADE"))
    
    repo_url = Column(String, nullable=True)
    demo_url = Column(String, nullable=True)
    notes = Column(Text, nullable=True)
    status = Column(Enum(SubmissionStatus, name="submission_status_enum", create_type=False), default=SubmissionStatus.ENROLLED)
    
    ai_score = Column(Integer, nullable=True)
    final_score = Column(Integer, nullable=True)
    feedback = Column(Text, nullable=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    completed_at = Column(DateTime(timezone=True), nullable=True)
    deleted_at = Column(DateTime(timezone=True), nullable=True)

    developer = relationship("User", back_populates="submissions")
    task = relationship("Task", back_populates="submissions")


# --- INBOX / MESSAGING ---

class MessageType(str, enum.Enum):
    OFFER = "offer"
    GIG = "gig"
    FEEDBACK = "feedback"
    GENERAL = "general"

class Conversation(Base):
    __tablename__ = "conversations"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("profiles.id"), index=True)
    
    sender_name = Column(String, nullable=False)
    sender_role = Column(String, nullable=True)
    sender_email = Column(String, nullable=True)
    sender_avatar_color = Column(String, default="#6366F1")
    
    message_type = Column(Enum(MessageType, name="message_type_enum", create_type=False), default=MessageType.GENERAL)
    subject = Column(String, nullable=True)
    is_read = Column(Boolean, default=False)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    messages = relationship("Message", back_populates="conversation", cascade="all, delete-orphan")
    user = relationship("User")


class Message(Base):
    __tablename__ = "messages"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    conversation_id = Column(String, ForeignKey("conversations.id", ondelete="CASCADE"), index=True)
    
    is_from_user = Column(Boolean, default=False)
    
    content = Column(Text, nullable=False)
    attachment_url = Column(String, nullable=True)
    attachment_type = Column(String, nullable=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    is_read = Column(Boolean, default=False)
    deleted_at = Column(DateTime(timezone=True), nullable=True)

    conversation = relationship("Conversation", back_populates="messages")


# --- EXPERIENCE / PORTFOLIO ---

class ExperienceType(str, enum.Enum):
    OPENSOURCE = "opensource"
    GIG = "gig"
    PROJECT = "project"
    HACKATHON = "hackathon"

class Experience(Base):
    __tablename__ = "experiences"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("profiles.id", ondelete="CASCADE"), index=True)
    
    title = Column(String, nullable=False)
    role = Column(String, nullable=True)
    experience_type = Column(Enum(ExperienceType, name="experience_type_enum", create_type=False), default=ExperienceType.PROJECT)
    
    description = Column(Text, nullable=True)
    contributions = Column(JSON, default=list)
    tech_stack = Column(JSON, default=list)
    
    project_url = Column(String, nullable=True)
    image_url = Column(String, nullable=True)
    
    start_date = Column(DateTime(timezone=True), nullable=True)
    end_date = Column(DateTime(timezone=True), nullable=True)
    is_current = Column(Boolean, default=False)
    
    is_verified = Column(Boolean, default=False)
    is_featured = Column(Boolean, default=False)
    display_order = Column(Integer, default=0)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="experiences")


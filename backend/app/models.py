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
    full_name = Column(String, nullable=True)
    hashed_password = Column(String)
    
    # Store domains as comma-separated string for now, or use Array in Postgres
    domains = Column(String, nullable=True) 

    # Gamification Stats
    total_xp = Column(Integer, default=0)
    level = Column(Integer, default=1)
    current_streak = Column(Integer, default=0)
    
    # JSON breakdown: {"design": 100, "code": 500, "product": 0}
    xp_breakdown = Column(JSON, default=dict)
    
    # Profile Extensions
    bio = Column(Text, nullable=True)
    avatar_url = Column(String, nullable=True)
    social_links = Column(JSON, default=dict) # {"github": "...", "linkedin": "...", "twitter": "..."}
    upi_id = Column(String, nullable=True) # For Payouts
    
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


# --- INBOX / MESSAGING ---

class MessageType(str, enum.Enum):
    OFFER = "offer"       # Job/role offer
    GIG = "gig"           # Short-term gig/contract
    FEEDBACK = "feedback" # Feedback on submission
    GENERAL = "general"   # General communication

class Conversation(Base):
    """
    A conversation thread between recruiter/admin and a user.
    Only recruiters/admins can initiate conversations.
    """
    __tablename__ = "conversations"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"), index=True)  # The talent receiving messages
    
    # Sender Details (Recruiter/Founder/Admin)
    sender_name = Column(String, nullable=False)
    sender_role = Column(String, nullable=True)  # e.g., "Founder @ NexusAI"
    sender_email = Column(String, nullable=True)
    sender_avatar_color = Column(String, default="#6366F1")  # Hex color for avatar
    
    # Conversation Metadata
    message_type = Column(Enum(MessageType, name="message_type"), default=MessageType.GENERAL)
    subject = Column(String, nullable=True)  # Optional subject line
    is_read = Column(Boolean, default=False)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    # Relationships
    messages = relationship("Message", back_populates="conversation", cascade="all, delete-orphan")
    user = relationship("User")


class Message(Base):
    """
    Individual messages within a conversation.
    """
    __tablename__ = "messages"

    id = Column(Integer, primary_key=True, index=True)
    conversation_id = Column(Integer, ForeignKey("conversations.id", ondelete="CASCADE"), index=True)
    
    # Sender identification
    is_from_user = Column(Boolean, default=False)  # True = user replied, False = recruiter sent
    
    # Content
    content = Column(Text, nullable=False)
    attachment_url = Column(String, nullable=True)  # URL to attached file/image
    attachment_type = Column(String, nullable=True)  # "image", "pdf", "link"
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    is_read = Column(Boolean, default=False)

    # Relationship
    conversation = relationship("Conversation", back_populates="messages")


# --- EXPERIENCE / PORTFOLIO ---

class ExperienceType(str, enum.Enum):
    OPENSOURCE = "opensource"  # Open source contributions
    GIG = "gig"               # Freelance/Contract work
    PROJECT = "project"       # Personal projects
    HACKATHON = "hackathon"   # Hackathon participation


class Experience(Base):
    """
    User's experience entries - open source contributions, gigs, projects.
    """
    __tablename__ = "experiences"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"), index=True)
    
    # Basic Info
    title = Column(String, nullable=False)  # Project/Company name
    role = Column(String, nullable=True)    # e.g., "Contributor", "Frontend Developer"
    experience_type = Column(Enum(ExperienceType, name="experience_type"), default=ExperienceType.PROJECT)
    
    # Details
    description = Column(Text, nullable=True)  # Brief description of the project
    contributions = Column(JSON, default=list)  # List of contributions: ["Fixed bug #123", "Added feature X"]
    tech_stack = Column(JSON, default=list)     # ["React", "Node.js", "Python"]
    
    # Links
    project_url = Column(String, nullable=True)   # GitHub repo, website, etc.
    image_url = Column(String, nullable=True)     # Project screenshot/logo
    
    # Duration
    start_date = Column(DateTime(timezone=True), nullable=True)
    end_date = Column(DateTime(timezone=True), nullable=True)  # Null = ongoing
    is_current = Column(Boolean, default=False)
    
    # Verification & Display
    is_verified = Column(Boolean, default=False)  # Admin verified
    is_featured = Column(Boolean, default=False)  # Show on profile
    display_order = Column(Integer, default=0)    # For custom ordering
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    # Relationship
    user = relationship("User", backref="experiences")


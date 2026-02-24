from pydantic import BaseModel, field_validator
from typing import Optional, List, Dict, Any
from datetime import datetime
from .models import DifficultyLevel, SubmissionStatus, TaskStatus, ExperienceType, MessageType

# --- TASK (DROPS) SCHEMAS ---

class TaskBase(BaseModel):
    title: str
    description: str
    bounty_amount: Optional[float] = 0.0
    category: Optional[str] = "backend"
    difficulty_level: Optional[int] = 1
    estimated_hours: Optional[int] = None
    status: Optional[TaskStatus] = TaskStatus.OPEN
    repo_url: Optional[str] = None
    requirements: Optional[List[str]] = []
    is_promoted: Optional[bool] = False
    deadline: Optional[datetime] = None
    max_submissions: Optional[int] = None

class TaskCreate(TaskBase):
    pass

class Task(TaskBase):
    id: str
    startup_id: str
    created_at: datetime

    class Config:
        from_attributes = True


# --- SUBMISSION SCHEMAS ---

class SubmissionCreate(BaseModel):
    task_id: str
    repo_url: Optional[str] = None
    demo_url: Optional[str] = None
    notes: Optional[str] = None

class Submission(BaseModel):
    id: str
    task_id: str
    developer_id: str
    repo_url: Optional[str] = None
    demo_url: Optional[str] = None
    notes: Optional[str] = None
    status: SubmissionStatus
    ai_score: Optional[int] = None
    final_score: Optional[int] = None
    feedback: Optional[str] = None
    created_at: datetime
    completed_at: Optional[datetime] = None

    class Config:
        from_attributes = True

class DeveloperSummary(BaseModel):
    id: str
    full_name: Optional[str] = None
    avatar_url: Optional[str] = None
    role: Optional[str] = None
    reputation_score: Optional[int] = 100
    upi_id: Optional[str] = None

class SubmissionWithDeveloper(Submission):
    developer: Optional[DeveloperSummary] = None

class SubmissionWithTask(Submission):
    task: Task

    class Config:
        from_attributes = True

class SubmissionWithTaskAndDeveloper(SubmissionWithTask):
    developer: Optional[DeveloperSummary] = None

    class Config:
        from_attributes = True


# --- USER (PROFILE) SCHEMAS ---

class UserBase(BaseModel):
    email: str
    full_name: Optional[str] = None

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    full_name: Optional[str] = None
    avatar_url: Optional[str] = None
    bio: Optional[str] = None
    skills: Optional[List[str]] = None
    role: Optional[str] = None
    website: Optional[str] = None
    location: Optional[str] = None
    industry: Optional[str] = None
    team_size: Optional[str] = None
    upi_id: Optional[str] = None

class User(UserBase):
    id: str
    avatar_url: Optional[str] = None
    role: Optional[str] = None
    bio: Optional[str] = None
    skills: Optional[List[str]] = []
    website: Optional[str] = None
    location: Optional[str] = None
    industry: Optional[str] = None
    team_size: Optional[str] = None
    upi_id: Optional[str] = None
    
    reputation_score: Optional[int] = 100
    wallet_balance: Optional[float] = 0.0

    total_xp: Optional[int] = 0
    level: Optional[int] = 1
    current_streak: Optional[int] = 0
    xp_breakdown: Optional[dict] = {}
    
    created_at: datetime
    updated_at: datetime

    @field_validator('total_xp', mode='before')
    @classmethod
    def coerce_total_xp(cls, v):
        return int(v) if v is not None else 0

    @field_validator('level', mode='before')
    @classmethod
    def coerce_level(cls, v):
        return int(v) if v is not None else 1

    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None

class UserStats(BaseModel):
    total_xp: Optional[int] = 0
    level: Optional[int] = 1
    completed_drops: int = 0
    rank: str = "Novice"
    xp_breakdown: Optional[dict] = {}

    @field_validator('total_xp', mode='before')
    @classmethod
    def coerce_total_xp(cls, v):
        return int(v) if v is not None else 0

    @field_validator('level', mode='before')
    @classmethod
    def coerce_level(cls, v):
        return int(v) if v is not None else 1

class LeaderboardEntry(BaseModel):
    id: str
    full_name: Optional[str] = None
    avatar_url: Optional[str] = None
    total_xp: Optional[int] = 0
    level: Optional[int] = 1

    @field_validator('total_xp', mode='before')
    @classmethod
    def coerce_total_xp(cls, v):
        return int(v) if v is not None else 0

    @field_validator('level', mode='before')
    @classmethod
    def coerce_level(cls, v):
        return int(v) if v is not None else 1

class ActivityEntry(BaseModel):
    user_id: str
    user_name: Optional[str]
    user_avatar: Optional[str]
    drop_title: str
    drop_domain: Optional[str]
    completed_at: datetime
    xp_earned: int


# --- INBOX / MESSAGING SCHEMAS ---

class MessageCreate(BaseModel):
    content: str
    attachment_url: Optional[str] = None
    attachment_type: Optional[str] = None

class Message(BaseModel):
    id: str
    conversation_id: str
    is_from_user: bool
    content: str
    attachment_url: Optional[str] = None
    attachment_type: Optional[str] = None
    created_at: datetime
    is_read: bool = False

    class Config:
        from_attributes = True

class ConversationCreate(BaseModel):
    user_id: str
    sender_name: str
    sender_role: Optional[str] = None
    sender_email: Optional[str] = None
    sender_avatar_color: Optional[str] = "#6366F1"
    message_type: Optional[str] = "general"
    subject: Optional[str] = None
    initial_message: str

class ConversationSummary(BaseModel):
    id: str
    sender_name: str
    sender_role: Optional[str] = None
    sender_avatar_color: str = "#6366F1"
    message_type: str = "general"
    subject: Optional[str] = None
    last_message: Optional[str] = None
    last_message_time: Optional[datetime] = None
    is_read: bool = False
    unread_count: int = 0
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class ConversationDetail(BaseModel):
    id: str
    sender_name: str
    sender_role: Optional[str] = None
    sender_email: Optional[str] = None
    sender_avatar_color: str = "#6366F1"
    message_type: str = "general"
    subject: Optional[str] = None
    is_read: bool = False
    created_at: datetime
    updated_at: datetime
    messages: List[Message] = []

    class Config:
        from_attributes = True


# --- EXPERIENCE / PORTFOLIO SCHEMAS ---

class ExperienceCreate(BaseModel):
    title: str
    role: Optional[str] = None
    experience_type: Optional[str] = "project" 
    description: Optional[str] = None
    contributions: Optional[List[str]] = []
    tech_stack: Optional[List[str]] = []
    project_url: Optional[str] = None
    image_url: Optional[str] = None
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    is_current: Optional[bool] = False
    is_featured: Optional[bool] = False

class ExperienceUpdate(BaseModel):
    title: Optional[str] = None
    role: Optional[str] = None
    experience_type: Optional[str] = None
    description: Optional[str] = None
    contributions: Optional[List[str]] = None
    tech_stack: Optional[List[str]] = None
    project_url: Optional[str] = None
    image_url: Optional[str] = None
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    is_current: Optional[bool] = None
    is_featured: Optional[bool] = None
    display_order: Optional[int] = None

class Experience(BaseModel):
    id: str
    user_id: str
    title: str
    role: Optional[str] = None
    experience_type: str = "project"
    description: Optional[str] = None
    contributions: List[str] = []
    tech_stack: List[str] = []
    project_url: Optional[str] = None
    image_url: Optional[str] = None
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    is_current: bool = False
    is_verified: bool = False
    is_featured: bool = False
    display_order: int = 0
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class ExperienceSummary(BaseModel):
    id: str
    title: str
    role: Optional[str] = None
    experience_type: str = "project"
    tech_stack: List[str] = []
    project_url: Optional[str] = None
    image_url: Optional[str] = None
    is_current: bool = False
    is_verified: bool = False

    class Config:
        from_attributes = True


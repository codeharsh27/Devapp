from pydantic import BaseModel, field_validator
from typing import Optional, List
from datetime import datetime
from .models import DifficultyLevel, SubmissionStatus

class DropBase(BaseModel):
    title: str
    description: Optional[str] = None
    domain: Optional[str] = None
    difficulty: Optional[DifficultyLevel] = DifficultyLevel.EASY
    time_limit_minutes: Optional[int] = 60
    reward_xp: Optional[int] = 100
    inputs_url: Optional[str] = None
    source_url: Optional[str] = None
    source_type: Optional[str] = "A"
    submission_type: Optional[str] = "code"

class DropCreate(DropBase):
    pass

class Drop(DropBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

class SubmissionCreate(BaseModel):
    drop_id: int
    submission_url: str
    doc_url: Optional[str] = None
    image_url: Optional[str] = None
    # user_id is now handled strictly via token, removing it from input payload is better practice
    # but if needed for some reason, it must be str.
    # user_id: str 

class Submission(BaseModel):
    id: int
    drop_id: int
    user_id: str
    submission_url: str
    doc_url: Optional[str] = None
    image_url: Optional[str] = None
    status: SubmissionStatus
    score: Optional[int] = None
    feedback: Optional[str] = None
    submitted_at: datetime

    class Config:
        from_attributes = True

class SubmissionWithDrop(Submission):
    drop: Drop

    class Config:
        from_attributes = True


class UserBase(BaseModel):
    email: str
    full_name: Optional[str] = None

class UserCreate(UserBase):
    password: str

class UserClassUpdate(BaseModel):
    domain: str

class UserUpdate(BaseModel):
    full_name: Optional[str] = None
    bio: Optional[str] = None
    avatar_url: Optional[str] = None
    social_links: Optional[dict] = None
    upi_id: Optional[str] = None

class User(UserBase):
    id: str
    bio: Optional[str] = None
    avatar_url: Optional[str] = None
    social_links: Optional[dict] = {}
    upi_id: Optional[str] = None
    
    # Gamification included in Profile - use Optional and coerce None
    total_xp: Optional[int] = 0
    level: Optional[int] = 1
    xp_breakdown: Optional[dict] = {}

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
    attachment_type: Optional[str] = None  # "image", "pdf", "link"

class Message(BaseModel):
    id: int
    conversation_id: int
    is_from_user: bool
    content: str
    attachment_url: Optional[str] = None
    attachment_type: Optional[str] = None
    created_at: datetime
    is_read: bool = False

    class Config:
        from_attributes = True

class ConversationCreate(BaseModel):
    """For admins to create a new conversation with a user"""
    user_id: str
    sender_name: str
    sender_role: Optional[str] = None
    sender_email: Optional[str] = None
    sender_avatar_color: Optional[str] = "#6366F1"
    message_type: Optional[str] = "general"  # offer, gig, feedback, general
    subject: Optional[str] = None
    initial_message: str  # The first message content

class ConversationSummary(BaseModel):
    """For listing conversations in inbox"""
    id: int
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
    """Full conversation with messages"""
    id: int
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
    """Create a new experience entry"""
    title: str
    role: Optional[str] = None
    experience_type: Optional[str] = "project"  # opensource, gig, project, hackathon
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
    """Update an experience entry"""
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
    """Experience response model"""
    id: int
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
    """Short experience summary for profile display"""
    id: int
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


from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from .models import DifficultyLevel, SubmissionStatus

class DropBase(BaseModel):
    title: str
    description: str
    domain: str
    difficulty: DifficultyLevel
    time_limit_minutes: int
    reward_xp: int
    inputs_url: Optional[str] = None

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


class UserBase(BaseModel):
    email: str
    full_name: Optional[str] = None

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: str
    # created_at removed to match models.User which lacks this column
    
    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None

class UserStats(BaseModel):
    total_xp: int
    level: int
    completed_drops: int
    rank: str = "Novice"

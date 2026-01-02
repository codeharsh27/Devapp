from pydantic import BaseModel, EmailStr
# Shared properties
class UserBase(BaseModel):
    email: EmailStr
    full_name: str | None = None
# Properties to receive via API on creation
class UserCreate(UserBase):
    password: str
# Properties to return to client (public user data)
class User(UserBase):
    id: int
    is_active: bool
    class Config:
        # This tells Pydantic: "It's okay to read data from a SQLAlchemy model"
        from_attributes = True
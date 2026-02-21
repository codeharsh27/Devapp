from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from .. import models, schemas, auth
from ..dependencies import get_db
import uuid

router = APIRouter(
    tags=["auth"]
)

@router.post("/register", response_model=schemas.User)
def register(user: schemas.UserCreate, db: Session = Depends(get_db)):
    # Check if user exists
    db_user = db.query(models.User).filter(models.User.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Hash password
    hashed_pw = auth.get_password_hash(user.password)
    
    # Create User
    # Generate a local UUID since we aren't using Supabase for this user
    new_id = str(uuid.uuid4())
    
    new_user = models.User(
        id=new_id,
        email=user.email,
        full_name=user.full_name,
        hashed_password=hashed_pw
    )
    
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@router.post("/token", response_model=schemas.Token)
def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == form_data.username).first()
    if not user or not user.hashed_password:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    if not auth.verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Generate Token
    # We include 'sub' as user_id for compatibility with get_current_user
    access_token = auth.create_access_token(
        data={"sub": user.id, "email": user.email}
    )
    
    return {"access_token": access_token, "token_type": "bearer"}

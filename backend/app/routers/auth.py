from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from .. import models, schemas, auth
from app.core.dependencies import get_db
import uuid

router = APIRouter(
    tags=["auth"]
)


@router.post("/register", response_model=schemas.User)
async def register(user: schemas.UserCreate, db: AsyncSession = Depends(get_db)):
    """Register a new user with a local (non-Supabase) account."""
    # Check if user already exists
    result = await db.execute(
        select(models.User).filter(models.User.email == user.email)
    )
    db_user = result.scalars().first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    # Hash password
    hashed_pw = auth.get_password_hash(user.password)

    # Generate a local UUID (not using Supabase for this path)
    new_id = str(uuid.uuid4())

    new_user = models.User(
        id=new_id,
        email=user.email,
        full_name=user.full_name,
        hashed_password=hashed_pw
    )

    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)
    return new_user


@router.post("/token", response_model=schemas.Token)
async def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: AsyncSession = Depends(get_db)
):
    """Exchange email + password for a JWT access token."""
    result = await db.execute(
        select(models.User).filter(models.User.email == form_data.username)
    )
    user = result.scalars().first()

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

    # Include user_id as 'sub' for compatibility with get_current_user
    access_token = auth.create_access_token(
        data={"sub": user.id, "email": user.email}
    )

    return {"access_token": access_token, "token_type": "bearer"}

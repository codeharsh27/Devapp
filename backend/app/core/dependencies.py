from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from jose import jwt, JWTError
import json
import urllib.request
import asyncio
import time
from typing import Optional, Dict, Any
from app.core import database
from app import models, auth
from app.core.config import settings

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Global JWKS Cache
jwks_cache: Dict[str, Any] = {}
jwks_last_fetched = 0
JWKS_CACHE_TTL = 3600 # 1 hour

# Re-export get_db from database for convenience
get_db = database.get_db

async def verify_token(token: str, db: AsyncSession):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        # Supabase returns HS256 signed JWTs with your project's JWT Secret
        # In development we can skip exp verification if tokens are stale for testing
        is_dev = settings.ENVIRONMENT == "development"
        verify_sig = True
        secret = settings.SECRET_KEY
        
        if settings.AUTH_MODE == "supabase":
            if settings.SUPABASE_JWT_SECRET:
                secret = settings.SUPABASE_JWT_SECRET
            elif is_dev:
                verify_sig = False

        options = {
            "verify_signature": verify_sig,
            "verify_aud": False,
            "verify_exp": not is_dev
        }

        payload = jwt.decode(
            token,
            secret,
            algorithms=["HS256"],
            options=options
        )
        
        user_id: str = payload.get("sub")
        email: str = payload.get("email")
        
        if user_id is None:
             raise credentials_exception
            
    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token has expired. Please log in again.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except jwt.JWTError as e:
        import logging
        logging.getLogger(__name__).warning(f"AUTH ERROR: {e}")
        raise credentials_exception
    except Exception:
        raise credentials_exception
    
    # Lazy Sync: Check if user exists in our local DB
    result = await db.execute(select(models.User).filter(models.User.id == user_id))
    user = result.scalars().first()
    
    if not user:
        # Create user (Upsert)
        user = models.User(id=user_id, email=email)
        db.add(user)
        try:
            await db.commit()
            await db.refresh(user)
        except Exception as e:
            await db.rollback()
            print("DB upsert failed:", e)
    elif user.email != email:
        user.email = email
        try:
            await db.commit()
            await db.refresh(user)
        except:
            await db.rollback()

    return user

async def get_current_user(token: str = Depends(oauth2_scheme), db: AsyncSession = Depends(get_db)):
    return await verify_token(token, db)

from app.core.exceptions import RBACException

async def get_startup_user(current_user: models.User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    # Verify Startup Profile exists
    from sqlalchemy.future import select
    from app.models import StartupProfile
    result = await db.execute(select(StartupProfile).filter(StartupProfile.user_id == current_user.id))
    profile = result.scalars().first()
    if not profile and current_user.role not in ["startup", "Founder", "Co-Founder"]: # Legacy fallback until db is clean
        raise RBACException("Only Startups can perform this action.")
    return current_user

async def get_talent_user(current_user: models.User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    # Verify Talent Profile exists
    from sqlalchemy.future import select
    from app.models import TalentProfile
    result = await db.execute(select(TalentProfile).filter(TalentProfile.user_id == current_user.id))
    profile = result.scalars().first()
    if not profile and current_user.role not in ["talent", "Developer"]: # Legacy fallback
        raise RBACException("Only Talent can perform this action.")
    return current_user

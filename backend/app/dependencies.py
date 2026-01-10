from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from jose import jwt, JWTError
import json
import urllib.request
import asyncio
import time
from typing import Optional, Dict, Any
from . import database, models

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Global JWKS Cache
jwks_cache: Dict[str, Any] = {}
jwks_last_fetched = 0
JWKS_CACHE_TTL = 3600 # 1 hour

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

async def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        # ROBUST AUTH: Verify using Supabase's Public Keys (JWKS)
        # We cache the keys to avoid blocking IO on every request.
        
        global jwks_cache, jwks_last_fetched
        
        current_time = time.time()
        SUPABASE_URL = "https://ntrubhipkhaoasqqkozu.supabase.co"
        jwks_url = f"{SUPABASE_URL}/auth/v1/.well-known/jwks.json"
        
        if not jwks_cache or (current_time - jwks_last_fetched > JWKS_CACHE_TTL):
            # Use run_in_executor to avoid blocking the async event loop with synchronous urllib
            loop = asyncio.get_event_loop()
            def fetch_jwks():
                with urllib.request.urlopen(jwks_url) as response:
                    return json.loads(response.read())
            
            jwks_cache = await loop.run_in_executor(None, fetch_jwks)
            jwks_last_fetched = current_time
            print("DEBUG: Refreshed JWKS Cache")
            
        # 2. Decode & Verify
        header = jwt.get_unverified_header(token)
        rsa_key = {}
        for key in jwks_cache["keys"]:
            if key["kid"] == header["kid"]:
                rsa_key = key
                break
                
        if not rsa_key:
             print("DEBUG: No matching key found in JWKS, trying force refresh...")
             # Force refresh once if key not found (maybe key rotation happened)
             loop = asyncio.get_event_loop() 
             def fetch_jwks():
                with urllib.request.urlopen(jwks_url) as response:
                    return json.loads(response.read())
             jwks_cache = await loop.run_in_executor(None, fetch_jwks)
             jwks_last_fetched = time.time()
             
             for key in jwks_cache["keys"]:
                if key["kid"] == header["kid"]:
                    rsa_key = key
                    break
             
             if not rsa_key:
                 print("DEBUG: Still no matching key found.")
                 raise credentials_exception

        payload = jwt.decode(
            token,
            rsa_key,
            algorithms=[header["alg"]],
            audience="authenticated"
        )

        user_id: str = payload.get("sub")
        email: str = payload.get("email")
        
        if user_id is None:
             raise credentials_exception
            
    except Exception as e:
        print(f"DEBUG: Auth Error: {e}")
        raise credentials_exception
    
    # Lazy Sync: Check if user exists in our local DB
    user = db.query(models.User).filter(models.User.id == user_id).first()
    
    if not user:
        # Create user (Upsert-ish)
        user = models.User(id=user_id, email=email)
        db.add(user)
        db.commit()
        db.refresh(user)
    elif user.email != email:
        # Update email if changed in Supabase
        user.email = email
    return user

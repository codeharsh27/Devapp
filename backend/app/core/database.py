from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, declarative_base
import os

# Fallback to SQLite if Postgres credentials fail or simpler local dev is needed
# SQLALCHEMY_DATABASE_URL = "postgresql+asyncpg://user:password@postgresserver/db"

from app.core.config import settings

url = settings.DATABASE_URL
if url.startswith("postgresql://"):
    url = url.replace("postgresql://", "postgresql+asyncpg://", 1)
elif url.startswith("sqlite:///"):
    url = url.replace("sqlite:///", "sqlite+aiosqlite:///", 1)

SQLALCHEMY_DATABASE_URL = url

# connect_args={"check_same_thread": False} is needed only for SQLite
connect_args = {"check_same_thread": False} if "sqlite" in SQLALCHEMY_DATABASE_URL else {}

engine = create_async_engine(
    SQLALCHEMY_DATABASE_URL, connect_args=connect_args, future=True
)
AsyncSessionLocal = sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False,
)

Base = declarative_base()

# Dependency to get DB session
async def get_db():
    async with AsyncSessionLocal() as session:
        yield session

from pydantic_settings import BaseSettings
from typing import List

class Settings(BaseSettings):
    DATABASE_URL: str
    SECRET_KEY: str
    SUPABASE_URL: str
    SUPABASE_KEY: str
    AUTH_MODE: str = "local"
    SENTRY_DSN: str = ""
    ALLOWED_ORIGINS: List[str] = ["http://localhost:3000"]
    ENVIRONMENT: str = "production"
    # Shared secret for authenticating internal Next.js → backend admin calls
    INTERNAL_API_SECRET: str = ""

    class Config:
        env_file = ".env"

settings = Settings()


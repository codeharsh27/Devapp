from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DATABASE_URL: str
    SECRET_KEY: str
    SUPABASE_URL: str
    SUPABASE_KEY: str
    AUTH_MODE: str = "local"
    SENTRY_DSN: str = ""
    ALLOWED_ORIGINS: list[str] = ["*"]
    ENVIRONMENT: str = "production"
    
    class Config:
        env_file = ".env"

settings = Settings()

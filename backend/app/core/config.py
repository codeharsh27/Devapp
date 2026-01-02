from pydantic_settings import BaseSettings

class settings(BaseSettings):
    PROJECT_NAME: str
    API_V1_STR: str = "/api/v1"
    DATABASE_URL: str
   
    class Config:
        # tells pydantic to read the env variables from the .env file
        env_file = ".env"
        case_sensitive = True
    
settings = settings()
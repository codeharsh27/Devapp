from fastapi import FastAPI 
from app.core.config import settings
from app.api.v1.router import api_router

# create app instance
# title and version help with documentation layer
app = FastAPI(title=settings.PROJECT_NAME, version="1.0.0")

# Include API router
app.include_router(api_router, prefix=settings.API_V1_STR)

# Define a route --> "Hello" endpoint
@app.get("/")
def read_root():    
    return{"status": "Success","message": "Backend is running"}
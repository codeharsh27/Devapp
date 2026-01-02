from fastapi import FastAPI
from app.schemas.news import NewsArticle
from typing import List
from app.services.scraper import NewsService
# Initialize the app
app = FastAPI(
    title="Devapp Production API",
    version = "1.0.0"
)

# Health Check - to verify if the server is running or not
@app.get("/")
def health_check():
    return{
        "status":"active",
        "message": "Production Server is Running"
    }

# News API
@app.get("/news", response_model=List[NewsArticle])
def get_news():
   service = NewsService()
   data = service.get_latest_news()
   return data
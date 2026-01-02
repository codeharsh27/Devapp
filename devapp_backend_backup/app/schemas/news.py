from pydantic import BaseModel

# defining the "Output" shape
class NewsArticle(BaseModel):
    title: str
    url: str
    source: str = "TechCrunch" 

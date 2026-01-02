from typing import List
class NewsService:
    def get_latest_news(self) -> List[dict]:
        return[
            {
                "title": "Refactored Logic workss!",
                "url": "https://fastapi.tiangolo.com/",
                "source": "Service Layer"
            }
        ]
from fastapi import APIRouter

api_router = APIRouter()

@api_router.get("/health")
def health_check():
    return {"status": "Success", "message": "Devapp Backend"}
    

from app.database import SessionLocal
from app.models import Drop

db = SessionLocal()
drops = db.query(Drop).all()
for drop in drops:
    print(f"ID: {drop.id}, SourceURL: {drop.source_url}, SourceType: {drop.source_type}")
db.close()

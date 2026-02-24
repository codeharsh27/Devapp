from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models import User, StartupProfile, TalentProfile

class ProfileRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_talent_for_update(self, user_id: str):
        result = await self.db.execute(select(TalentProfile).filter(TalentProfile.user_id == user_id).with_for_update())
        return result.scalars().first()

    async def get_startup_for_update(self, user_id: str):
        result = await self.db.execute(select(StartupProfile).filter(StartupProfile.user_id == user_id).with_for_update())
        return result.scalars().first()

    async def get_user_for_update(self, user_id: str):
        result = await self.db.execute(select(User).filter(User.id == user_id).with_for_update())
        return result.scalars().first()

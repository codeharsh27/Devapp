from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from app.models import Submission, SubmissionStatus
import uuid

class SubmissionRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_by_id(self, submission_id: str):
        result = await self.db.execute(select(Submission).filter(Submission.id == submission_id, Submission.deleted_at == None))
        return result.scalars().first()

    async def get_by_id_for_update(self, submission_id: str):
        result = await self.db.execute(select(Submission).filter(Submission.id == submission_id, Submission.deleted_at == None).with_for_update())
        return result.scalars().first()

    async def get_by_task_and_talent(self, task_id: str, talent_id: str):
        result = await self.db.execute(
            select(Submission).filter(
                Submission.task_id == task_id,
                Submission.developer_id == talent_id,
                Submission.deleted_at == None
            )
        )
        return result.scalars().first()

    async def create_enrollment(self, task_id: str, talent_id: str):
        sub = Submission(
            id=str(uuid.uuid4()),
            task_id=task_id,
            developer_id=talent_id,
            status=SubmissionStatus.ENROLLED
        )
        self.db.add(sub)
        await self.db.flush()
        return sub

    async def get_all_by_task(self, task_id: str):
        result = await self.db.execute(
            select(Submission)
            .options(selectinload(Submission.developer))
            .filter(Submission.task_id == task_id, Submission.deleted_at == None)
        )
        return result.scalars().all()

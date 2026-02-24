from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models import Task, TaskStatus
import uuid

class TaskRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_all_open(self):
        result = await self.db.execute(select(Task).filter(Task.status == TaskStatus.OPEN, Task.deleted_at == None))
        return result.scalars().all()

    async def get_by_id(self, task_id: str):
        result = await self.db.execute(select(Task).filter(Task.id == task_id, Task.deleted_at == None))
        return result.scalars().first()

    async def get_by_id_for_update(self, task_id: str):
        # Row level lock for transaction
        result = await self.db.execute(select(Task).filter(Task.id == task_id, Task.deleted_at == None).with_for_update())
        return result.scalars().first()

    async def create(self, startup_id: str, data: dict):
        task = Task(id=str(uuid.uuid4()), startup_id=startup_id, **data)
        self.db.add(task)
        await self.db.flush()
        return task

    async def update_status(self, task: Task, status: TaskStatus):
        task.status = status
        await self.db.flush()
        return task

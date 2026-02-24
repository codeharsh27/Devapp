from sqlalchemy.ext.asyncio import AsyncSession
from app.domains.tasks.repository import TaskRepository
from app.domains.submissions.repository import SubmissionRepository
from app.domains.profiles.repository import ProfileRepository
from app.core.exceptions import BusinessRuleException, RBACException
from app.models import TaskStatus, SubmissionStatus
from datetime import datetime, timezone

class TaskService:
    def __init__(self, db: AsyncSession):
        self.db = db
        self.task_repo = TaskRepository(db)
        self.sub_repo = SubmissionRepository(db)
        self.profile_repo = ProfileRepository(db)

    async def create_task(self, startup_id: str, data: dict):
        return await self.task_repo.create(startup_id, data)

    async def enroll(self, task_id: str, talent_id: str):
        async with self.db.begin():
            # Check if enrolled
            existing = await self.sub_repo.get_by_task_and_talent(task_id, talent_id)
            if existing:
                raise BusinessRuleException("ALREADY_ENROLLED", "You are already enrolled in this task.")
                
            task = await self.task_repo.get_by_id_for_update(task_id)
            if not task or task.status != TaskStatus.OPEN:
                raise BusinessRuleException("TASK_NOT_OPEN", "This task is not open for enrollment")

            # Update task status if it's the first submission
            if task.status == TaskStatus.OPEN:
                await self.task_repo.update_status(task, TaskStatus.IN_PROGRESS)

            return await self.sub_repo.create_enrollment(task_id, talent_id)

    async def submit_work(self, task_id: str, talent_id: str, repo_url: str, demo_url: str = None, notes: str = None):
        async with self.db.begin():
            sub = await self.sub_repo.get_by_task_and_talent(task_id, talent_id)
            if not sub:
                raise BusinessRuleException("NOT_ENROLLED", "You are not enrolled in this task")
                
            if sub.status not in [SubmissionStatus.ENROLLED, SubmissionStatus.FAILED]:
                raise BusinessRuleException("INVALID_STATUS", "Submission is not in a submittable state")

            sub.repo_url = repo_url
            sub.demo_url = demo_url
            sub.notes = notes
            sub.status = SubmissionStatus.PENDING
            await self.db.flush()
            return sub

    async def review_submission(self, task_id: str, submission_id: str, startup_id: str, action: str, feedback: str = None):
        """
        Transactional Review & Reward Process.
        Ensure only the task creator reviews it, lock row, transfer bounty.
        Valid actions: ACCEPT, REJECT
        """
        async with self.db.begin():
            task = await self.task_repo.get_by_id_for_update(task_id)
            if not task:
                raise BusinessRuleException("NOT_FOUND", "Task not found")

            if task.startup_id != startup_id:
                raise RBACException("Only the startup that created this task can review it")

            sub = await self.sub_repo.get_by_id_for_update(submission_id)
            if not sub or sub.task_id != task_id:
                raise BusinessRuleException("NOT_FOUND", "Submission not found for this task")

            if sub.status != SubmissionStatus.PENDING:
                raise BusinessRuleException("ALREADY_REVIEWED", "Submission is not pending review a decision has already been made")

            if action == "ACCEPT":
                sub.status = SubmissionStatus.EVALUATED
                sub.final_score = 100
                sub.completed_at = datetime.now(timezone.utc)
                sub.feedback = feedback

                # Reward talent
                talent = await self.profile_repo.get_user_for_update(sub.developer_id)
                talent_profile = await self.profile_repo.get_talent_for_update(sub.developer_id)

                # Assign XP based on difficulty, roughly
                xp_gained = (task.difficulty_level or 1) * 100
                talent.total_xp = (talent.total_xp or 0) + xp_gained
                
                # Check for Bounty Award
                if task.bounty_amount and task.bounty_amount > 0:
                    startup = await self.profile_repo.get_user_for_update(startup_id)
                    # Deduct from startup
                    if float(startup.wallet_balance or 0) >= float(task.bounty_amount):
                        startup.wallet_balance = float(startup.wallet_balance) - float(task.bounty_amount)
                        talent.wallet_balance = float(talent.wallet_balance or 0) + float(task.bounty_amount)
                    else:
                        raise BusinessRuleException("INSUFFICIENT_FUNDS", "Startup does not have enough balance to pay the bounty.")

                # Close the Task
                task.status = TaskStatus.COMPLETED

                # Refresh Level calculations
                talent.level = int(talent.total_xp / 1000) + 1

            elif action == "REJECT":
                sub.status = SubmissionStatus.FAILED
                sub.feedback = feedback
            else:
                raise BusinessRuleException("INVALID_ACTION", "Review action must be ACCEPT or REJECT")

            await self.db.flush()
            return sub

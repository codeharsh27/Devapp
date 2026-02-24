from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from app.models import Conversation, Message
from sqlalchemy import desc, func
import uuid

class ChatRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_user_conversations(self, user_id: str, message_type: str = None):
        stmt = select(Conversation).filter(Conversation.user_id == user_id, Conversation.deleted_at == None)
        if message_type:
            stmt = stmt.filter(Conversation.message_type == message_type)
        stmt = stmt.order_by(desc(Conversation.updated_at))
        result = await self.db.execute(stmt)
        return result.scalars().all()

    async def get_conversation_by_id(self, conv_id: str, user_id: str):
        result = await self.db.execute(
            select(Conversation).filter(
                Conversation.id == conv_id, 
                Conversation.user_id == user_id,
                Conversation.deleted_at == None
            )
        )
        return result.scalars().first()
        
    async def get_conversation_by_id_admin(self, conv_id: str):
        result = await self.db.execute(
            select(Conversation).filter(
                Conversation.id == conv_id,
                Conversation.deleted_at == None
            )
        )
        return result.scalars().first()

    async def get_conversation_messages(self, conv_id: str):
        stmt = select(Message).filter(Message.conversation_id == conv_id, Message.deleted_at == None).order_by(Message.created_at)
        result = await self.db.execute(stmt)
        return result.scalars().all()
        
    async def get_last_message(self, conv_id: str):
        stmt = select(Message).filter(Message.conversation_id == conv_id, Message.deleted_at == None).order_by(desc(Message.created_at)).limit(1)
        result = await self.db.execute(stmt)
        return result.scalars().first()

    async def get_unread_count(self, conv_id: str):
        stmt = select(func.count()).select_from(Message).filter(
            Message.conversation_id == conv_id,
            Message.is_from_user == False,
            Message.is_read == False,
            Message.deleted_at == None
        )
        result = await self.db.execute(stmt)
        return result.scalar_one()

    async def mark_messages_read(self, conv_id: str):
        from sqlalchemy import update
        update_stmt = update(Message).where(
            Message.conversation_id == conv_id,
            Message.is_from_user == False,
            Message.deleted_at == None
        ).values(is_read=True)
        await self.db.execute(update_stmt)

    async def create_message(self, data: dict):
        msg = Message(id=str(uuid.uuid4()), **data)
        self.db.add(msg)
        await self.db.flush()
        return msg
        
    async def create_conversation(self, data: dict):
        conv = Conversation(id=str(uuid.uuid4()), **data)
        self.db.add(conv)
        await self.db.flush()
        return conv

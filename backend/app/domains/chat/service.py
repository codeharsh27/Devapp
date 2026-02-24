from sqlalchemy.ext.asyncio import AsyncSession
from app.domains.chat.repository import ChatRepository
from app.core.exceptions import BusinessRuleException
from datetime import datetime, timezone
from app.websockets import manager

class ChatService:
    def __init__(self, db: AsyncSession):
        self.db = db
        self.repo = ChatRepository(db)

    async def get_user_inbox(self, user_id: str, message_type: str = None):
        conversations = await self.repo.get_user_conversations(user_id, message_type)
        summary_list = []
        for conv in conversations:
            last_msg = await self.repo.get_last_message(conv.id)
            unread_count = await self.repo.get_unread_count(conv.id)
            
            summary_list.append({
                "id": conv.id,
                "sender_name": conv.sender_name,
                "sender_role": conv.sender_role,
                "sender_avatar_color": conv.sender_avatar_color or "#6366F1",
                "message_type": conv.message_type.value if conv.message_type else "general",
                "subject": conv.subject,
                "last_message": last_msg.content[:100] if last_msg else None,
                "last_message_time": last_msg.created_at if last_msg else conv.created_at,
                "is_read": conv.is_read,
                "unread_count": unread_count,
                "created_at": conv.created_at,
                "updated_at": conv.updated_at
            })
        return summary_list

    async def get_conversation_detail(self, conv_id: str, user_id: str):
        async with self.db.begin():
            conv = await self.repo.get_conversation_by_id(conv_id, user_id)
            if not conv:
                raise BusinessRuleException("NOT_FOUND", "Conversation not found", 404)
            
            conv.is_read = True
            await self.repo.mark_messages_read(conv.id)
            
            messages = await self.repo.get_conversation_messages(conv.id)
            
            # Flush changes from marking as read
            await self.db.flush()
            
            return conv, messages
            
    async def send_user_reply(self, conv_id: str, user_id: str, content: str, attachment_url: str = None, attachment_type: str = None):
        async with self.db.begin():
            conv = await self.repo.get_conversation_by_id(conv_id, user_id)
            if not conv:
                 raise BusinessRuleException("NOT_FOUND", "Conversation not found", 404)
                 
            msg = await self.repo.create_message({
                "conversation_id": conv.id,
                "is_from_user": True,
                "content": content,
                "attachment_url": attachment_url,
                "attachment_type": attachment_type
            })
            
            conv.updated_at = datetime.now(timezone.utc)
            await self.db.flush()
            
            return msg
            
    async def admin_create_conversation(self, data: dict, initial_message: str):
        async with self.db.begin():
            from app.models import MessageType
            msg_type = MessageType.GENERAL
            if data.get("message_type"):
                try: 
                    msg_type = MessageType(data["message_type"].lower())
                except:
                    pass
            data["message_type"] = msg_type
            
            conv = await self.repo.create_conversation(data)
            
            msg = await self.repo.create_message({
                "conversation_id": conv.id,
                "is_from_user": False,
                "content": initial_message
            })
            
            # Send Realtime WebSocket Ping to target user
            await manager.send_personal_message({
                 "type": "new_chat_message",
                 "data": {
                     "conversation_id": conv.id,
                     "sender": conv.sender_name,
                     "preview": initial_message[:50]
                 }
            }, data["user_id"])
            
            return conv
            
    async def admin_send_message(self, conv_id: str, content: str, attachment_url: str = None, attachment_type: str = None):
         async with self.db.begin():
             conv = await self.repo.get_conversation_by_id_admin(conv_id)
             if not conv:
                  raise BusinessRuleException("NOT_FOUND", "Conversation not found", 404)
                  
             msg = await self.repo.create_message({
                 "conversation_id": conv.id,
                 "is_from_user": False,
                 "content": content,
                 "attachment_url": attachment_url,
                 "attachment_type": attachment_type
             })
             
             conv.updated_at = datetime.now(timezone.utc)
             conv.is_read = False
             
             await self.db.flush()
             
             await manager.send_personal_message({
                 "type": "new_chat_message",
                 "data": {
                     "conversation_id": conv.id,
                     "sender": conv.sender_name,
                     "preview": content[:50]
                 }
            }, conv.user_id)
             
             return msg

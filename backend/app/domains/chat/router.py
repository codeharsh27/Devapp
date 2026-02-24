from fastapi import APIRouter, Depends, Header, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional
import os
from app import schemas
from app.core.dependencies import get_db, get_current_user
from app.models import User
from app.domains.chat.service import ChatService

router = APIRouter(
    prefix="/api/v1/chat",
    tags=["chat"],
)

INTERNAL_API_SECRET = os.environ.get("INTERNAL_API_SECRET", "")

def _verify_admin_secret(x_internal_secret: str = Header("")):
    if not INTERNAL_API_SECRET:
        raise HTTPException(status_code=500, detail="Server misconfiguration: INTERNAL_API_SECRET is not set.")
    if x_internal_secret != INTERNAL_API_SECRET:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Forbidden: invalid or missing internal secret.")

# --- USER ENDPOINTS ---

@router.get("", response_model=List[schemas.ConversationSummary])
async def get_my_conversations(
    message_type: Optional[str] = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    svc = ChatService(db)
    return await svc.get_user_inbox(current_user.id, message_type)

@router.get("/{conversation_id}", response_model=schemas.ConversationDetail)
async def get_conversation(
    conversation_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    svc = ChatService(db)
    conv, messages = await svc.get_conversation_detail(conversation_id, current_user.id)
    return {
        "id": conv.id,
        "sender_name": conv.sender_name,
        "sender_role": conv.sender_role,
        "sender_email": conv.sender_email,
        "sender_avatar_color": conv.sender_avatar_color or "#6366F1",
        "message_type": conv.message_type.value if conv.message_type else "general",
        "subject": conv.subject,
        "is_read": conv.is_read,
        "created_at": conv.created_at,
        "updated_at": conv.updated_at,
        "messages": [schemas.Message.model_validate(m) for m in messages]
    }

@router.post("/{conversation_id}/messages", response_model=schemas.Message)
async def send_message(
    conversation_id: str,
    message: schemas.MessageCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    svc = ChatService(db)
    return await svc.send_user_reply(
        conv_id=conversation_id,
        user_id=current_user.id,
        content=message.content,
        attachment_url=message.attachment_url,
        attachment_type=message.attachment_type
    )

# --- ADMIN ENDPOINTS (System/Startups) ---

@router.post("/admin/conversations", response_model=schemas.ConversationDetail)
async def admin_create_conversation(
    data: schemas.ConversationCreate,
    db: AsyncSession = Depends(get_db),
    _: None = Depends(_verify_admin_secret),
):
    svc = ChatService(db)
    # The actual payload mapped from User schema
    conv_data = {
       "user_id": data.user_id,
       "sender_name": data.sender_name,
       "sender_role": data.sender_role,
       "sender_email": data.sender_email,
       "sender_avatar_color": data.sender_avatar_color,
       "message_type": data.message_type,
       "subject": data.subject
    }
    conv = await svc.admin_create_conversation(conv_data, data.initial_message)
    # Return constructed detail
    return {
        "id": conv.id,
        "sender_name": conv.sender_name,
        "sender_role": conv.sender_role,
        "sender_email": conv.sender_email,
        "sender_avatar_color": conv.sender_avatar_color or "#6366F1",
        "message_type": conv.message_type.value if conv.message_type else "general",
        "subject": conv.subject,
        "is_read": conv.is_read,
        "created_at": conv.created_at,
        "updated_at": conv.updated_at,
        "messages": [schemas.Message.model_validate(m) for m in await svc.repo.get_conversation_messages(conv.id)]
    }

@router.post("/admin/conversations/{conversation_id}/messages", response_model=schemas.Message)
async def admin_send_message(
    conversation_id: str,
    message: schemas.MessageCreate,
    db: AsyncSession = Depends(get_db),
    _: None = Depends(_verify_admin_secret),
):
    svc = ChatService(db)
    return await svc.admin_send_message(
        conv_id=conversation_id, 
        content=message.content, 
        attachment_url=message.attachment_url, 
        attachment_type=message.attachment_type
    )

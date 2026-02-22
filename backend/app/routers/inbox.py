"""
Inbox Router - Handles conversations and messages between recruiters and users.

Key Features:
- Users can only receive messages (not initiate)
- Users can reply within existing conversations
- Users can send attachments
- Messages persist until user explicitly deletes
"""

from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import desc, func, update, delete
from typing import List, Optional
from datetime import datetime, timezone
import os
from .. import models, schemas
from ..dependencies import get_db, get_current_user

router = APIRouter(
    prefix="/inbox",
    tags=["inbox"],
    responses={404: {"description": "Not found"}},
)


# --- USER ENDPOINTS ---

@router.get("", response_model=List[schemas.ConversationSummary])
async def get_my_conversations(
    message_type: Optional[str] = None,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get all conversations for the current user.
    Optionally filter by message_type: 'offer', 'gig', 'feedback', 'general'
    """
    stmt = select(models.Conversation).filter(
        models.Conversation.user_id == current_user.id
    )
    
    if message_type:
        stmt = stmt.filter(models.Conversation.message_type == message_type)
    
    stmt = stmt.order_by(desc(models.Conversation.updated_at))
    result = await db.execute(stmt)
    conversations = result.scalars().all()
    
    # Build summary with last message
    summary_list = []
    for conv in conversations:
        # Get last message
        last_msg_stmt = select(models.Message).filter(
            models.Message.conversation_id == conv.id
        ).order_by(desc(models.Message.created_at)).limit(1)
        
        last_msg_res = await db.execute(last_msg_stmt)
        last_msg = last_msg_res.scalars().first()
        
        # Count unread messages
        count_stmt = select(func.count()).select_from(models.Message).filter(
            models.Message.conversation_id == conv.id,
            models.Message.is_from_user == False,  # Messages from recruiter
            models.Message.is_read == False
        )
        count_res = await db.execute(count_stmt)
        unread_count = count_res.scalar_one()
        
        summary_list.append(schemas.ConversationSummary(
            id=conv.id,
            sender_name=conv.sender_name,
            sender_role=conv.sender_role,
            sender_avatar_color=conv.sender_avatar_color or "#6366F1",
            message_type=conv.message_type.value if conv.message_type else "general",
            subject=conv.subject,
            last_message=last_msg.content[:100] if last_msg else None,
            last_message_time=last_msg.created_at if last_msg else conv.created_at,
            is_read=conv.is_read,
            unread_count=unread_count,
            created_at=conv.created_at,
            updated_at=conv.updated_at
        ))
    
    return summary_list


@router.get("/{conversation_id}", response_model=schemas.ConversationDetail)
async def get_conversation(
    conversation_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get a specific conversation with all messages.
    Also marks the conversation as read.
    """
    stmt = select(models.Conversation).filter(
        models.Conversation.id == conversation_id,
        models.Conversation.user_id == current_user.id
    )
    result = await db.execute(stmt)
    conv = result.scalars().first()
    
    if not conv:
        raise HTTPException(status_code=404, detail="Conversation not found")
    
    # Mark conversation and all recruiter messages as read
    conv.is_read = True
    
    update_stmt = update(models.Message).where(
        models.Message.conversation_id == conversation_id,
        models.Message.is_from_user == False
    ).values(is_read=True)
    
    await db.execute(update_stmt)
    await db.commit()
    
    # Get all messages
    msgs_stmt = select(models.Message).filter(
        models.Message.conversation_id == conversation_id
    ).order_by(models.Message.created_at)
    
    msgs_res = await db.execute(msgs_stmt)
    messages = msgs_res.scalars().all()
    
    return schemas.ConversationDetail(
        id=conv.id,
        sender_name=conv.sender_name,
        sender_role=conv.sender_role,
        sender_email=conv.sender_email,
        sender_avatar_color=conv.sender_avatar_color or "#6366F1",
        message_type=conv.message_type.value if conv.message_type else "general",
        subject=conv.subject,
        is_read=conv.is_read,
        created_at=conv.created_at,
        updated_at=conv.updated_at,
        messages=[schemas.Message.model_validate(m) for m in messages]
    )


@router.post("/{conversation_id}/messages", response_model=schemas.Message)
async def send_message(
    conversation_id: int,
    message: schemas.MessageCreate,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Send a message (reply) in an existing conversation.
    Users can only reply to conversations initiated by recruiters.
    """
    # Verify conversation exists and belongs to user
    stmt = select(models.Conversation).filter(
        models.Conversation.id == conversation_id,
        models.Conversation.user_id == current_user.id
    )
    result = await db.execute(stmt)
    conv = result.scalars().first()
    
    if not conv:
        raise HTTPException(status_code=404, detail="Conversation not found")
    
    # Create message
    new_message = models.Message(
        conversation_id=conversation_id,
        is_from_user=True,  # User is sending this
        content=message.content,
        attachment_url=message.attachment_url,
        attachment_type=message.attachment_type,
    )
    
    db.add(new_message)
    
    # Update conversation timestamp
    conv.updated_at = datetime.now(timezone.utc)
    
    await db.commit()
    await db.refresh(new_message)
    
    return new_message


@router.delete("/{conversation_id}")
async def delete_conversation(
    conversation_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Delete a conversation and all its messages.
    Only the user can delete their own conversations.
    """
    stmt = select(models.Conversation).filter(
        models.Conversation.id == conversation_id,
        models.Conversation.user_id == current_user.id
    )
    result = await db.execute(stmt)
    conv = result.scalars().first()
    
    if not conv:
        raise HTTPException(status_code=404, detail="Conversation not found")
    
    await db.delete(conv)  # Cascade will delete messages
    await db.commit()
    
    return {"message": "Conversation deleted"}



# ---------------------------------------------------------------------------
# Internal admin helper — validates the shared secret so only trusted
# internal callers (e.g. Next.js API routes) can trigger admin actions.
# ---------------------------------------------------------------------------

INTERNAL_API_SECRET = os.environ.get("INTERNAL_API_SECRET", "")

def _verify_admin_secret(x_internal_secret: str = Header("")):
    """Dependency — raises 403 if the caller cannot prove it is an internal service."""
    if not INTERNAL_API_SECRET:
        raise HTTPException(
            status_code=500,
            detail="Server misconfiguration: INTERNAL_API_SECRET is not set."
        )
    if x_internal_secret != INTERNAL_API_SECRET:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: invalid or missing internal secret.",
        )


@router.post("/admin/conversations", response_model=schemas.ConversationDetail)
async def create_conversation(
    data: schemas.ConversationCreate,
    db: AsyncSession = Depends(get_db),
    _: None = Depends(_verify_admin_secret),
):
    """
    Create a new conversation with a user.
    This endpoint is for recruiters/admins to initiate contact.
    
    In production, this should require admin authentication.
    """
    # Verify user exists
    user_res = await db.execute(select(models.User).filter(models.User.id == data.user_id))
    user = user_res.scalars().first()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Map message_type string to enum
    msg_type = models.MessageType.GENERAL
    if data.message_type:
        try:
            msg_type = models.MessageType(data.message_type.lower())
        except ValueError:
            msg_type = models.MessageType.GENERAL
    
    # Create conversation
    conv = models.Conversation(
        user_id=data.user_id,
        sender_name=data.sender_name,
        sender_role=data.sender_role,
        sender_email=data.sender_email,
        sender_avatar_color=data.sender_avatar_color or "#6366F1",
        message_type=msg_type,
        subject=data.subject,
    )
    db.add(conv)
    await db.flush()  # Get the ID
    
    # Create initial message
    initial_msg = models.Message(
        conversation_id=conv.id,
        is_from_user=False,  # Recruiter is sending
        content=data.initial_message,
    )
    db.add(initial_msg)
    
    await db.commit()
    await db.refresh(conv)
    
    # Return with messages
    msgs_stmt = select(models.Message).filter(
        models.Message.conversation_id == conv.id
    )
    msgs_res = await db.execute(msgs_stmt)
    messages = msgs_res.scalars().all()
    
    return schemas.ConversationDetail(
        id=conv.id,
        sender_name=conv.sender_name,
        sender_role=conv.sender_role,
        sender_email=conv.sender_email,
        sender_avatar_color=conv.sender_avatar_color or "#6366F1",
        message_type=conv.message_type.value if conv.message_type else "general",
        subject=conv.subject,
        is_read=conv.is_read,
        created_at=conv.created_at,
        updated_at=conv.updated_at,
        messages=[schemas.Message.model_validate(m) for m in messages]
    )


@router.post("/admin/conversations/{conversation_id}/messages", response_model=schemas.Message)
async def admin_send_message(
    conversation_id: int,
    message: schemas.MessageCreate,
    db: AsyncSession = Depends(get_db),
    _: None = Depends(_verify_admin_secret),
):
    """
    Send a message as a recruiter/admin in an existing conversation.
    
    In production, this should require admin authentication.
    """
    stmt = select(models.Conversation).filter(
        models.Conversation.id == conversation_id
    )
    result = await db.execute(stmt)
    conv = result.scalars().first()
    
    if not conv:
        raise HTTPException(status_code=404, detail="Conversation not found")
    
    new_message = models.Message(
        conversation_id=conversation_id,
        is_from_user=False,  # Admin/Recruiter sending
        content=message.content,
        attachment_url=message.attachment_url,
        attachment_type=message.attachment_type,
    )
    
    db.add(new_message)
    conv.updated_at = datetime.now(timezone.utc)
    conv.is_read = False  # Mark as unread for user
    
    await db.commit()
    await db.refresh(new_message)
    
    return new_message

import logging
from fastapi import APIRouter, WebSocket, status
from sqlalchemy.ext.asyncio import AsyncSession
from ..websockets import manager
from ..dependencies import get_db, verify_token
from fastapi import Depends

logger = logging.getLogger(__name__)

router = APIRouter()


@router.websocket("/ws")
async def websocket_endpoint(
    websocket: WebSocket,
    token: str,
    db: AsyncSession = Depends(get_db),
):
    try:
        user = await verify_token(token, db)
    except Exception as e:
        logger.warning(f"WebSocket auth failed: {type(e).__name__}")
        await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
        return

    await manager.connect(websocket, user.id)
    try:
        while True:
            await websocket.receive_text()
    except Exception:
        # Client disconnected — clean up gracefully
        manager.disconnect(websocket, user.id)

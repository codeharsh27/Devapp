from fastapi import APIRouter, WebSocket, Depends, status
from sqlalchemy.orm import Session
from ..websockets import manager
from ..dependencies import get_db, verify_token

router = APIRouter()

@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket, token: str, db: Session = Depends(get_db)):
    try:
        user = await verify_token(token, db)
    except Exception as e:
        print(f"WS Auth Failed: {e}")
        await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
        return

    await manager.connect(websocket, user.id)
    try:
        while True:
            await websocket.receive_text()
    except:
        manager.disconnect(websocket, user.id)

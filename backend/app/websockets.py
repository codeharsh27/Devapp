"""
WebSocket connection manager for real-time backend → client notifications.

Usage scope: submission evaluation results, leaderboard pings, admin alerts.
Chat messages are handled by Supabase Realtime, not this manager.

Scalability note: This is an in-process store — it works correctly with a
single Uvicorn worker. For multi-worker setups you MUST replace
`send_personal_message` / `broadcast` with Redis Pub/Sub so messages reach
the worker that holds the target socket. Add a TODO in the backlog before
horizontally scaling the backend.
"""

import asyncio
import logging
from typing import Dict, List
from fastapi import WebSocket
from starlette.websockets import WebSocketState

logger = logging.getLogger(__name__)


class ConnectionManager:
    def __init__(self):
        # user_id → list of active WebSockets (one user may have multiple tabs open)
        self._connections: Dict[str, List[WebSocket]] = {}

    async def connect(self, websocket: WebSocket, user_id: str) -> None:
        await websocket.accept()
        self._connections.setdefault(user_id, []).append(websocket)
        logger.debug("WS connected: user=%s total_sockets=%d", user_id, len(self._connections[user_id]))

    def disconnect(self, websocket: WebSocket, user_id: str) -> None:
        sockets = self._connections.get(user_id, [])
        if websocket in sockets:
            sockets.remove(websocket)
        if not sockets:
            self._connections.pop(user_id, None)
        logger.debug("WS disconnected: user=%s", user_id)

    def is_connected(self, user_id: str) -> bool:
        return bool(self._connections.get(user_id))

    async def send_personal_message(self, message: dict, user_id: str) -> None:
        """
        Send `message` to all open sockets for `user_id`.
        Stale (closed) sockets are cleaned up automatically.
        """
        sockets = list(self._connections.get(user_id, []))
        if not sockets:
            return

        dead: List[WebSocket] = []
        for ws in sockets:
            if ws.client_state != WebSocketState.CONNECTED:
                dead.append(ws)
                continue
            try:
                await ws.send_json(message)
            except Exception as exc:
                logger.warning("WS send failed for user=%s: %s", user_id, exc)
                dead.append(ws)

        # Prune dead sockets
        for ws in dead:
            self.disconnect(ws, user_id)

    async def broadcast(self, message: dict) -> None:
        """Send `message` to every connected user."""
        # Copy keys so we can mutate _connections during iteration
        for user_id in list(self._connections.keys()):
            await self.send_personal_message(message, user_id)


manager = ConnectionManager()

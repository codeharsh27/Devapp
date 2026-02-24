"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { toast } from "sonner";

export function useLiveActivity() {
    const [lastEvent, setLastEvent] = useState<any>(null);

    useEffect(() => {
        let ws: WebSocket | null = null;
        let isConnecting = false;

        const connect = async () => {
            if (isConnecting) return;
            isConnecting = true;

            try {
                const supabase = createClient();
                const { data: { session } } = await supabase.auth.getSession();
                const token = session?.access_token;

                if (!token) {
                    isConnecting = false;
                    return;
                }

                // Make sure to use correct ws path
                const wsBase = process.env.NEXT_PUBLIC_BACKEND_URL
                    ? process.env.NEXT_PUBLIC_BACKEND_URL.replace('http', 'ws')
                    : 'ws://localhost:8000';

                const wsUrl = `${wsBase}/ws?token=${token}`;

                ws = new WebSocket(wsUrl);

                ws.onmessage = (event) => {
                    try {
                        const data = JSON.parse(event.data);
                        if (data.type === 'submission_update') {
                            const taskTitle = data.data.task_title;
                            const status = data.data.status;
                            const score = data.data.score;

                            const Msg = `Mission "${taskTitle}" status changed to ${status}${score >= 0 ? ` with score ${score}` : ''}`;
                            toast.success(Msg, {
                                duration: 8000
                            });

                            setLastEvent({
                                type: data.type,
                                message: Msg,
                                timestamp: Date.now()
                            });
                        }
                        // Handle other realtime push events here
                    } catch (e) {
                        console.error('Failed to parse WS message', e);
                    }
                };

                ws.onclose = () => {
                    // Try to reconnect after an interval
                    setTimeout(connect, 5000);
                };
            } catch (err) {
                console.error("WS connect error:", err);
            } finally {
                isConnecting = false;
            }
        };

        connect();

        return () => {
            if (ws) {
                ws.onclose = null; // Prevent reconnect on unmount
                ws.close();
            }
        };
    }, []);

    return { lastEvent };
}

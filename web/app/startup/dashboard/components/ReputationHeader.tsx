"use client";
import { Trophy, Bell, X } from "lucide-react";

export function ReputationHeader({
    onNotificationClick,
    isNotificationView
}: {
    onNotificationClick?: () => void,
    isNotificationView?: boolean
}) {

    return (
        <div className="absolute top-0 right-0 p-6 z-30 flex items-center justify-end w-full pointer-events-none">
            <button
                onClick={onNotificationClick}
                className="relative w-10 h-10 rounded-full bg-[#0c0c0e]/80 backdrop-blur-md border border-zinc-800 flex items-center justify-center text-zinc-400 hover:text-white hover:bg-zinc-800 transition-all shadow-sm group pointer-events-auto cursor-pointer"
            >
                {isNotificationView ? (
                    <X className="w-5 h-5 group-hover:rotate-90 transition-transform duration-200" />
                ) : (
                    <>
                        <Bell className="w-5 h-5 group-hover:scale-110 transition-transform" />
                        <div className="absolute top-2.5 right-2.5 w-2 h-2 bg-red-500 rounded-full border border-[#0c0c0e]"></div>
                    </>
                )}
            </button>
        </div>
    );
}


import { Loader2, ChefHat } from "lucide-react";

export function PageLoader() {
    return (
        <div className="flex flex-col h-[50vh] w-full items-center justify-center gap-4 animate-in fade-in duration-500">
            <div className="relative">
                <ChefHat className="h-10 w-10 text-indigo-500 animate-bounce" />
                <div className="absolute -bottom-2 -right-2">
                    <Loader2 className="h-5 w-5 animate-spin text-emerald-400" />
                </div>
            </div>
            <div className="text-zinc-400 font-medium tracking-wide flex items-center gap-2">
                We are cooking for you<span className="animate-pulse">...</span>
            </div>
        </div>
    );
}

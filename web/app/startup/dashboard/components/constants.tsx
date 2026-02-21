"use client";
import {
    Code2, Layout, Smartphone, PenTool, Bug, Check
} from "lucide-react";
import { ReactNode } from "react";

export type Category = {
    id: string;
    label: string;
    icon: ReactNode;
};

export const CATEGORIES: Category[] = [
    { id: 'backend', label: 'Backend / API', icon: <Code2 className="w-4 h-4" /> },
    { id: 'frontend', label: 'Frontend / UI', icon: <Layout className="w-4 h-4" /> },
    { id: 'mobile', label: 'Mobile App', icon: <Smartphone className="w-4 h-4" /> },
    { id: 'design', label: 'Design System', icon: <PenTool className="w-4 h-4" /> },
    { id: 'debug', label: 'Debugging', icon: <Bug className="w-4 h-4" /> },
];

export const ROTATING_WORDS = ["Frontend UI", "Backend API", "System Design", "Debugging", "Mobile App"];

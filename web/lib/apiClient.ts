// lib/apiClient.ts
// Reusable client to talk to the FastAPI Backend

export const BACKEND_URL = process.env.NEXT_PUBLIC_BACKEND_URL || "http://localhost:8000";

interface FetchOptions extends RequestInit {
    token?: string | null;
}

export async function fetchApi<T>(endpoint: string, options: FetchOptions = {}): Promise<T> {
    const { token, headers, ...rest } = options;

    const mergedHeaders: Record<string, string> = {
        'Content-Type': 'application/json',
        ...(headers as Record<string, string> || {})
    };

    if (token) {
        mergedHeaders['Authorization'] = `Bearer ${token}`;
    }

    // Ensure endpoint starts with slash
    const url = `${BACKEND_URL}${endpoint.startsWith('/') ? endpoint : `/${endpoint}`}`;

    const response = await fetch(url, {
        headers: mergedHeaders,
        ...rest,
    });

    if (!response.ok) {
        let errorMsg = 'An error occurred';
        try {
            const errorData = await response.json();
            errorMsg = errorData.detail || errorData.message || response.statusText;
        } catch {
            errorMsg = response.statusText;
        }
        throw new Error(errorMsg);
    }

    // Handle empty responses
    if (response.status === 204) {
        return {} as T;
    }

    return response.json();
}

'use client';

import { useEffect } from 'react';
import { useAppDispatch } from '@/lib/store/hooks';
import { setAuth, clearAuth, setAuthLoading } from '@/lib/store/slices/authSlice';
import { createClient } from '@/lib/supabase/client';
import { fetchApi } from '@/lib/apiClient';

export function GlobalAuthSync() {
    const dispatch = useAppDispatch();

    useEffect(() => {
        const supabase = createClient();

        const fetchProfile = async (session: any) => {
            if (!session?.access_token) {
                dispatch(clearAuth());
                return;
            }

            try {
                // We use our helper so auth token is attached properly
                const profile = await fetchApi<any>('/users/me', { token: session.access_token });
                if (profile) {
                    dispatch(setAuth({
                        id: profile.id,
                        email: profile.email || '',
                        role: profile.role || null,
                        full_name: profile.full_name || null,
                        avatar_url: profile.avatar_url || null,
                        reputation_score: profile.reputation_score || 0
                    }));
                } else {
                    dispatch(clearAuth());
                }
            } catch (err) {
                console.error("Failed to fetch profile in GlobalAuthSync:", err);
                dispatch(clearAuth());
            }
        };

        const initializeAuth = async () => {
            dispatch(setAuthLoading(true));
            const { data: { session } } = await supabase.auth.getSession();
            await fetchProfile(session);
        };

        initializeAuth();

        const { data: { subscription } } = supabase.auth.onAuthStateChange(
            async (_event, session) => {
                dispatch(setAuthLoading(true));
                await fetchProfile(session);
            }
        );

        return () => {
            subscription.unsubscribe();
        };
    }, [dispatch]);

    return null;
}

import { createSlice, PayloadAction } from '@reduxjs/toolkit';

interface UserProfile {
    id: string;
    email: string;
    role: string | null;
    full_name: string | null;
    avatar_url: string | null;
    reputation_score: number;
}

interface AuthState {
    user: UserProfile | null;
    isAuthenticated: boolean;
    isLoading: boolean;
}

const initialState: AuthState = {
    user: null,
    isAuthenticated: false,
    isLoading: true, // starts loading while session checks
};

const authSlice = createSlice({
    name: 'auth',
    initialState,
    reducers: {
        setAuth(state, action: PayloadAction<UserProfile>) {
            state.user = action.payload;
            state.isAuthenticated = true;
            state.isLoading = false;
        },
        clearAuth(state) {
            state.user = null;
            state.isAuthenticated = false;
            state.isLoading = false;
        },
        setAuthLoading(state, action: PayloadAction<boolean>) {
            state.isLoading = action.payload;
        },
    },
});

export const { setAuth, clearAuth, setAuthLoading } = authSlice.actions;
export default authSlice.reducer;

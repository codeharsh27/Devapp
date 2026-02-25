'use client';

import { Provider } from 'react-redux';
import { store } from './store';
import { GlobalAuthSync } from '@/components/GlobalAuthSync';

export function ReduxProvider({ children }: { children: React.ReactNode }) {
    return (
        <Provider store={store}>
            <GlobalAuthSync />
            {children}
        </Provider>
    );
}

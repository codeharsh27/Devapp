import { createSlice, PayloadAction } from '@reduxjs/toolkit';

export interface ChatMessage {
    id: string;
    conversation_id: string;
    content: string;
    is_from_user: boolean;
    sender_id: string;
    created_at: string;
    attachment_url?: string | null;
    attachment_type?: string | null;
}

export interface ConversationSummary {
    id: string;
    sender_name: string;
    participant?: { full_name: string, avatar_url: string };
    last_message?: { text: string, created_at: string } | null;
    unread_count: number;
    updated_at: string;
}

interface ChatState {
    conversations: ConversationSummary[];
    activeConversationId: string | null;
    messages: Record<string, ChatMessage[]>; // keyed by conversationId
    globalUnreadCount: number;
    isOpen: boolean; // whether chat sidebar or modal is globally open
}

const initialState: ChatState = {
    conversations: [],
    activeConversationId: null,
    messages: {},
    globalUnreadCount: 0,
    isOpen: false,
};

const chatSlice = createSlice({
    name: 'chat',
    initialState,
    reducers: {
        setConversations(state, action: PayloadAction<ConversationSummary[]>) {
            state.conversations = action.payload;
            state.globalUnreadCount = action.payload.reduce((acc, c) => acc + (c.unread_count || 0), 0);
        },
        setMessages(state, action: PayloadAction<{ conversationId: string, messages: ChatMessage[] }>) {
            state.messages[action.payload.conversationId] = action.payload.messages;
        },
        addMessage(state, action: PayloadAction<ChatMessage>) {
            const { conversation_id } = action.payload;
            if (!state.messages[conversation_id]) {
                state.messages[conversation_id] = [];
            }
            // avoid duplicates
            const exists = state.messages[conversation_id].find(m => m.id === action.payload.id);
            if (!exists) {
                state.messages[conversation_id].push(action.payload);
            }
        },
        setActiveConversation(state, action: PayloadAction<string | null>) {
            state.activeConversationId = action.payload;
        },
        toggleChatWindow(state, action: PayloadAction<boolean | undefined>) {
            if (action.payload !== undefined) {
                state.isOpen = action.payload;
            } else {
                state.isOpen = !state.isOpen;
            }
        },
        markConversationRead(state, action: PayloadAction<string>) {
            const conv = state.conversations.find(c => c.id === action.payload);
            if (conv && conv.unread_count > 0) {
                state.globalUnreadCount -= conv.unread_count;
                conv.unread_count = 0;
            }
        }
    },
});

export const {
    setConversations, setMessages, addMessage, setActiveConversation, toggleChatWindow, markConversationRead
} = chatSlice.actions;

export default chatSlice.reducer;

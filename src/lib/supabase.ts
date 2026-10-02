import { createClient } from '@supabase/supabase-js';

// Polyfill native WebSocket for Node 20 and earlier server environments
if (typeof window === 'undefined' && typeof globalThis.WebSocket === 'undefined') {
    try {
        // eslint-disable-next-line @typescript-eslint/no-var-requires
        globalThis.WebSocket = require('ws');
    } catch (e) {
        globalThis.WebSocket = class DummyWebSocket {} as any;
    }
}

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

export const isSupabaseConfigured = () => {
    return Boolean(supabaseUrl && supabaseAnonKey && supabaseUrl !== 'https://your-supabase-project.supabase.co');
};

// Create a single supabase client for interacting with your database
export const supabase = isSupabaseConfigured()
    ? createClient(supabaseUrl, supabaseAnonKey, {
        auth: { persistSession: false },
      })
    : null;

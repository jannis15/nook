import { createClient, type SupabaseClient } from '@supabase/supabase-js';
import type { Database } from '../db/types.js';
import { env } from '../env.js';

export type Supabase = SupabaseClient<Database>;
export type Profile = Database['public']['Tables']['profiles']['Row'];

export function createSupabaseForToken(accessToken: string) {
  return createClient<Database>(env.supabaseUrl, env.supabasePublishableKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
    global: {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    },
  });
}

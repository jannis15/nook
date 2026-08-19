import { createClient, type SupabaseClient } from '@supabase/supabase-js';
import type { Database } from '../db/types.js';
import { env } from '../env.js';

export type Supabase = SupabaseClient<Database>;
export type Profile = Database['public']['Tables']['profiles']['Row'];
export type MediaRow = Database['public']['Tables']['media']['Row'];
export type MediaInsert = Database['public']['Tables']['media']['Insert'];

export function createSupabaseAdminClient() {
  return createClient<Database>(env.supabaseUrl, env.supabaseSecretKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
  });
}

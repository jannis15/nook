import type { Profile, Supabase } from '../lib/supabase.js';

const profileColumns = 'id, email, username, created_at, updated_at';

export async function findProfileById(
  supabase: Supabase,
  userId: string,
): Promise<Profile | null> {
  const { data, error } = await supabase
    .from('profiles')
    .select(profileColumns)
    .eq('id', userId)
    .maybeSingle();

  if (error) {
    throw error;
  }

  return data;
}

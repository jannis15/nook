import type { Profile, Supabase } from '../lib/supabase.js';

const profileColumns = 'id, email, display_name, created_at, updated_at';

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

export async function updateProfileDisplayName(
  supabase: Supabase,
  userId: string,
  displayName: string | null,
): Promise<Profile> {
  const { data, error } = await supabase
    .from('profiles')
    .update({ display_name: displayName })
    .eq('id', userId)
    .select(profileColumns)
    .single();

  if (error) {
    throw error;
  }

  return data;
}

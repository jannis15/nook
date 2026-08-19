import type { MediaInsert, MediaRow, Supabase } from '../lib/supabase.js';

const mediaColumns = [
  'id',
  'owner_id',
  'storage_key',
  'original_filename',
  'title',
  'upload_expires_at',
  'description',
  'media_type',
  'mime_type',
  'file_size',
  'content_hash',
  'width',
  'height',
  'duration_seconds',
  'captured_at',
  'status',
  'processing_error',
  'metadata',
  'created_at',
  'updated_at',
] satisfies Array<keyof MediaRow>;

const mediaSelect = mediaColumns.join(',');

export type ListMediaFilters = {
  mediaType?: 'image' | 'video';
  status?: 'pending' | 'processing' | 'ready' | 'failed';
  limit: number;
};

export async function createMedia(
  supabase: Supabase,
  media: MediaInsert,
): Promise<MediaRow> {
  const { data, error } = await supabase
    .from('media')
    .insert(media)
    .select(mediaSelect)
    .single()
    .returns<MediaRow>();

  if (error) {
    throw error;
  }

  return data;
}

export async function updateMedia(
  supabase: Supabase,
  userId: string,
  mediaId: string,
  media: Partial<MediaInsert>,
): Promise<MediaRow> {
  const { data, error } = await supabase
    .from('media')
    .update(media)
    .eq('owner_id', userId)
    .eq('id', mediaId)
    .select(mediaSelect)
    .single()
    .returns<MediaRow>();

  if (error) {
    throw error;
  }

  return data;
}

export async function listMedia(
  supabase: Supabase,
  userId: string,
  filters: ListMediaFilters,
): Promise<MediaRow[]> {
  let query = supabase
    .from('media')
    .select(mediaSelect)
    .eq('owner_id', userId)
    .order('created_at', { ascending: false })
    .limit(filters.limit);

  if (filters.mediaType) {
    query = query.eq('media_type', filters.mediaType);
  }

  if (filters.status) {
    query = query.eq('status', filters.status);
  }

  const { data, error } = await query.returns<MediaRow[]>();

  if (error) {
    throw error;
  }

  return data;
}

export async function listExpiredPendingMedia(
  supabase: Supabase,
  userId: string,
  now: string,
): Promise<MediaRow[]> {
  const { data, error } = await supabase
    .from('media')
    .select(mediaSelect)
    .eq('owner_id', userId)
    .eq('status', 'pending')
    .lt('upload_expires_at', now)
    .returns<MediaRow[]>();

  if (error) {
    throw error;
  }

  return data;
}

export async function findMediaById(
  supabase: Supabase,
  userId: string,
  mediaId: string,
): Promise<MediaRow | null> {
  const { data, error } = await supabase
    .from('media')
    .select(mediaSelect)
    .eq('owner_id', userId)
    .eq('id', mediaId)
    .maybeSingle()
    .returns<MediaRow | null>();

  if (error) {
    throw error;
  }

  return data;
}

export async function deleteMediaById(
  supabase: Supabase,
  userId: string,
  mediaId: string,
): Promise<void> {
  const { error } = await supabase
    .from('media')
    .delete()
    .eq('owner_id', userId)
    .eq('id', mediaId);

  if (error) {
    throw error;
  }
}

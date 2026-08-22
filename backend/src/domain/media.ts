import type { Json } from '../db/types.js';
import type { MediaRow } from '../lib/supabase.js';

export type MediaStatus = 'pending' | 'processing' | 'ready' | 'failed';

export type BaseMediaEntity = {
  id: string;
  ownerId: string;
  storageKey: string;
  originalFilename: string;
  title: string | null;
  description: string | null;
  mimeType: string;
  fileSize: number;
  metadata: Json;
  createdAt: string;
  updatedAt: string;
};

export type MediaProcessingState =
  | {
      status: Exclude<MediaStatus, 'failed'>;
      processingError: null;
    }
  | {
      status: 'failed';
      processingError: string;
    };

export type ImageMediaEntity = BaseMediaEntity &
  MediaProcessingState & {
    mediaType: 'image';
  };

export type VideoMediaEntity = BaseMediaEntity &
  MediaProcessingState & {
    mediaType: 'video';
  };

export type MediaEntity = ImageMediaEntity | VideoMediaEntity;

export function toMediaEntity(row: MediaRow): MediaEntity {
  const base = {
    id: row.id,
    ownerId: row.owner_id,
    storageKey: row.storage_key,
    originalFilename: row.original_filename,
    title: row.title,
    description: row.description,
    mimeType: row.mime_type,
    fileSize: row.file_size,
    metadata: row.metadata,
    createdAt: row.created_at,
    updatedAt: row.updated_at,
  } satisfies BaseMediaEntity;
  const processingState = toMediaProcessingState(row);

  if (row.media_type === 'video') {
    return {
      ...base,
      ...processingState,
      mediaType: 'video',
    };
  }

  return {
    ...base,
    ...processingState,
    mediaType: 'image',
  };
}

function toMediaProcessingState(row: MediaRow): MediaProcessingState {
  if (row.status === 'failed' && row.processing_error?.trim()) {
    return { status: 'failed', processingError: row.processing_error };
  }

  if (
    (row.status === 'pending' ||
      row.status === 'processing' ||
      row.status === 'ready') &&
    row.processing_error === null
  ) {
    return { status: row.status, processingError: null };
  }

  throw new Error('Media status and processing error are inconsistent');
}

create type public.media_type as enum ('image', 'video');
create type public.media_status as enum ('pending', 'processing', 'ready', 'failed');

create table public.media (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  storage_key text not null,
  original_filename text not null,
  title text,
  description text,
  media_type public.media_type not null,
  mime_type text not null,
  file_size bigint not null,
  content_hash text,
  width integer,
  height integer,
  duration_seconds numeric,
  captured_at timestamptz,
  status public.media_status not null default 'pending',
  processing_error text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint media_file_size_check check (file_size >= 0),
  constraint media_width_check check (width is null or width > 0),
  constraint media_height_check check (height is null or height > 0),
  constraint media_duration_seconds_check check (
    duration_seconds is null or duration_seconds >= 0
  ),
  constraint media_processing_error_status_check check (
    (status = 'failed' and length(btrim(processing_error)) > 0)
    or (status <> 'failed' and processing_error is null)
  ),
  constraint media_owner_storage_key_unique unique (owner_id, storage_key)
);

create trigger media_set_updated_at
before update on public.media
for each row execute function public.set_updated_at();

create index media_owner_uploaded_idx on public.media (owner_id, created_at desc, id desc);
create index media_owner_captured_idx on public.media (owner_id, captured_at desc);
create index media_owner_media_type_idx on public.media (owner_id, media_type);
create index media_owner_status_idx on public.media (owner_id, status);
create index media_owner_content_hash_idx on public.media (owner_id, content_hash)
where content_hash is not null;
create index media_metadata_idx on public.media using gin (metadata);

alter table public.media enable row level security;

revoke all on table public.media from anon, authenticated;
grant all on table public.media to service_role;

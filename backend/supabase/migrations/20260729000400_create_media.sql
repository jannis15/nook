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
  status public.media_status not null default 'pending',
  processing_error text,
  processing_lease_token uuid,
  processing_lease_expires_at timestamptz,
  processing_attempt_count integer not null default 0,
  preview_storage_key text,
  blur_hash text,
  content_hash text,
  width integer,
  height integer,
  duration_seconds double precision,
  preview_timestamp_seconds double precision,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint media_file_size_check check (file_size >= 0),
  constraint media_processing_attempt_count_check check (processing_attempt_count >= 0),
  constraint media_processing_error_status_check check (
    (status = 'failed' and length(btrim(processing_error)) > 0)
    or (status <> 'failed' and processing_error is null)
  ),
  constraint media_dimensions_check check (
    (width is null and height is null)
    or (width > 0 and height > 0)
  ),
  constraint media_content_hash_check check (
    content_hash is null or content_hash ~ '^[0-9a-f]{64}$'
  ),
  constraint media_duration_check check (
    duration_seconds is null or duration_seconds >= 0
  ),
  constraint media_preview_timestamp_check check (
    preview_timestamp_seconds is null or preview_timestamp_seconds >= 0
  ),
  constraint media_owner_storage_key_unique unique (owner_id, storage_key)
);

create trigger media_set_updated_at
before update on public.media
for each row execute function public.set_updated_at();

create index media_owner_uploaded_idx on public.media (owner_id, created_at desc, id desc);
create index media_owner_media_type_idx on public.media (owner_id, media_type);
create index media_owner_status_idx on public.media (owner_id, status);
create index media_processing_claim_idx on public.media (created_at, id)
where status = 'processing';
create index media_owner_content_hash_idx on public.media (owner_id, content_hash)
where content_hash is not null;
create index media_metadata_idx on public.media using gin (metadata);

alter table public.media enable row level security;

revoke all on table public.media from anon, authenticated;
grant all on table public.media to service_role;

create function public.claim_media_processing_jobs(
  p_limit integer default 10,
  p_lease_seconds integer default 900
)
returns setof public.media
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_limit < 1 or p_limit > 100 then
    raise exception 'p_limit must be between 1 and 100';
  end if;
  if p_lease_seconds < 30 or p_lease_seconds > 3600 then
    raise exception 'p_lease_seconds must be between 30 and 3600';
  end if;

  return query
  with candidates as (
    select id
    from public.media
    where status = 'processing'
      and (processing_lease_expires_at is null or processing_lease_expires_at <= now())
    order by created_at, id
    limit p_limit
    for update skip locked
  ), claimed as (
    update public.media media
    set processing_lease_token = gen_random_uuid(),
        processing_lease_expires_at = now() + make_interval(secs => p_lease_seconds),
        processing_attempt_count = media.processing_attempt_count + 1
    from candidates
    where media.id = candidates.id
    returning media.*
  )
  select * from claimed;
end;
$$;

create function public.finalize_media_processing_job(
  p_media_id uuid,
  p_lease_token uuid,
  p_status public.media_status,
  p_processing_error text default null,
  p_preview_storage_key text default null,
  p_blur_hash text default null,
  p_content_hash text default null,
  p_width integer default null,
  p_height integer default null,
  p_duration_seconds double precision default null,
  p_preview_timestamp_seconds double precision default null
)
returns setof public.media
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_status not in ('ready', 'failed') then
    raise exception 'p_status must be ready or failed';
  end if;
  if p_status = 'failed' and nullif(btrim(p_processing_error), '') is null then
    raise exception 'failed jobs require p_processing_error';
  end if;
  if p_status = 'ready' and (
    p_preview_storage_key is null or p_blur_hash is null or p_content_hash is null
    or p_width is null or p_height is null
  ) then
    raise exception 'ready jobs require preview and metadata';
  end if;

  return query
  update public.media media
  set status = p_status,
      processing_error = case when p_status = 'failed' then left(btrim(p_processing_error), 1000) else null end,
      processing_lease_token = null,
      processing_lease_expires_at = null,
      preview_storage_key = case when p_status = 'ready' then p_preview_storage_key else null end,
      blur_hash = case when p_status = 'ready' then p_blur_hash else null end,
      content_hash = case when p_status = 'ready' then p_content_hash else null end,
      width = case when p_status = 'ready' then p_width else null end,
      height = case when p_status = 'ready' then p_height else null end,
      duration_seconds = case when p_status = 'ready' then p_duration_seconds else null end,
      preview_timestamp_seconds = case when p_status = 'ready' then p_preview_timestamp_seconds else null end
  where media.id = p_media_id
    and media.status = 'processing'
    and media.processing_lease_token = p_lease_token
    and media.processing_lease_expires_at > now()
  returning media.*;
end;
$$;

revoke all on function public.claim_media_processing_jobs(integer, integer) from public, anon, authenticated;
revoke all on function public.finalize_media_processing_job(uuid, uuid, public.media_status, text, text, text, text, integer, integer, double precision, double precision) from public, anon, authenticated;
grant execute on function public.claim_media_processing_jobs(integer, integer) to service_role;
grant execute on function public.finalize_media_processing_job(uuid, uuid, public.media_status, text, text, text, text, integer, integer, double precision, double precision) to service_role;

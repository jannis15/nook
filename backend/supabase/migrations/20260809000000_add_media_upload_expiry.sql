alter table public.media
add column upload_expires_at timestamptz;

update public.media
set upload_expires_at = created_at
where upload_expires_at is null;

alter table public.media
alter column upload_expires_at set not null;

create index media_pending_upload_expiry_idx
on public.media (owner_id, upload_expires_at)
where status = 'pending';

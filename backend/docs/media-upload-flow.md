# Media Upload and Read Flow

This document describes the media flow implemented by the backend today. It
covers initial uploads and reads; media updates and file replacement do not yet
exist.

## Overview

Media is uploaded in three client-driven steps:

1. The client asks the backend to initialize an upload.
2. The client uploads bytes directly to the private Supabase Storage bucket.
3. The client tells the backend to complete the upload. The backend verifies
   the stored object before making the media available for reads.

The backend creates a `media` database record before any file bytes are
uploaded. That record reserves a unique storage path and tracks the upload
state.

## Upload Flow

### 1. Initialize

The authenticated client calls `POST /media/uploads` with:

```json
{
  "filename": "photo.jpg",
  "mime_type": "image/jpeg",
  "file_size": 12345
}
```

The backend validates the metadata before creating anything:

- Supported images: JPEG, PNG, WebP, and GIF, up to 10 MB.
- Supported videos: MP4, WebM, QuickTime, M4V, AVI, and Matroska, up to 100 MB.
- File names must be non-empty and sizes must be positive integers.

After validation, the backend:

1. Generates a new media UUID.
2. Creates a `media` row owned by the authenticated user with `status` set to
   `pending`.
3. Creates a unique object key in the form
   `<user-id>/media/<media-id>/original-<sanitized-filename>`.
4. Creates a signed Supabase Storage upload URL valid for two hours.

It returns HTTP `201` with the media ID, pending status, signed upload URL, and
expiry time.

### 2. Upload Bytes

The client uploads the original bytes directly to the returned signed URL using
HTTP `PUT`. The backend does not proxy file bytes.

The current Flutter client sends `x-upsert: false`, so the upload is create-only.
The storage bucket is private, and direct authenticated access to Storage and
application tables is denied. The signed upload URL is the narrowly scoped,
time-limited capability that permits this upload.

Together with the UUID-based object key, this prevents a normal initial upload
from overwriting another media object's file. File replacement is not currently
implemented and will require an explicit replacement/versioning design.

The backend uses Supabase's secret key and explicitly scopes all data access by
the authenticated user ID. The secret key is backend-only and must never be
provided to the Flutter client.

### 3. Complete and Verify

After the direct upload succeeds, the client calls
`POST /media/{media-id}/complete`.

This is how the backend is notified that the client believes the upload
succeeded. There is currently no storage webhook, background worker, polling,
or other asynchronous upload notification.

The backend verifies that:

- The media row belongs to the authenticated user.
- The record is still `pending`, unless it is already `ready`.
- The two-hour upload period has not expired.
- An object exists at the reserved storage key.
- The object size reported by Storage exactly matches the file size supplied at
  initialization.

On success, the backend sets the record to `ready`, clears any processing error,
and returns HTTP `200` with the full media response. Calling completion again
for a ready item returns the ready media again.

If verification fails, the backend removes the stored object when possible,
sets the record to `failed`, and records a processing error. An expired pending
upload is also failed when completion is attempted.

The media table enforces the status/error relationship: failed media must have
a non-blank processing error, and all other statuses must have no processing
error. The backend domain model represents the same invariant.

Before each new initialization, the backend removes expired pending uploads for
that user when it can remove their storage objects, then deletes their database
records.

## Reading Media

`GET /media` returns only the authenticated user's `ready` media records. It
does not include original-media URLs.

`GET /media/{media-id}` returns one authenticated user's media record and a
signed `media_url` for the original object. Read URLs are valid for one hour.
Both list and detail responses include metadata such as media type, MIME type,
file size, status, dimensions, and capture time.

## Content Hash

The `media.content_hash` column exists and is exposed as `content_hash` in media
API responses. It is currently not calculated or written by the backend, so it
is `null` for newly uploaded media.

The database has an owner-scoped index for non-null content hashes. This
suggests a future use for efficient same-owner content identity or duplicate
detection, but no duplicate detection, integrity verification, or hash-based
behavior is implemented today.

## Current Limits

- Only original files are uploaded; metadata extraction is not part of upload
  completion.
- No media update endpoint exists.
- No file replacement endpoint exists.
- Completion verifies object existence and byte size, not MIME contents or a
  cryptographic content hash.

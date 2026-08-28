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

`GET /media` returns the authenticated user's media records, including uploads
that are still pending or processing. It
uses opaque keyset pagination: the first request omits `cursor`, and each
response returns a `next_cursor` for the next page or `null` when exhausted.
It does not include original-media URLs.

`GET /media/{media-id}` returns one authenticated user's media record and a
signed `media_url` for the original object. Read URLs are valid for one hour.
Both list and detail responses include media type, MIME type, file size, and
status.

### Processing Status Long Poll

`GET /media/{media-id}/status?wait=25` returns the authenticated user's current
media record without creating a signed original URL. `wait` is an integer from
zero to 25 seconds and defaults to 25.

For `pending` or `processing` media, the endpoint waits up to the requested
duration and rechecks the record once per second. It returns immediately when
the item reaches `ready` or `failed`; when the timeout expires, it returns the
latest non-terminal status. The Flutter client immediately opens another
long-poll request while the item remains non-terminal. It permits at most four
concurrent status requests and queues additional items locally.

The selected original bytes stay in the pending library card during this wait,
so an image does not disappear while the server creates its preview. Once the
status is `ready`, the response provides the signed preview URL and the client
replaces the local pending item. The client does not connect directly to
Supabase or poll Storage.

## Current Limits

- Only original files are uploaded; metadata extraction is not part of upload
  completion.
- No media update endpoint exists.
- No file replacement endpoint exists.
- Completion verifies object existence and byte size, not MIME contents.

## Planned Previews and Content Hashes

The current implementation stores and serves originals only. The following is
the intended contract for adding fast gallery previews without changing the
original-file behavior.

### Implementation Status

The `media` table and API response contract now include nullable preview
storage, BlurHash, content hash, dimensions, duration, and video poster
timestamp fields. List and detail responses include `preview_url` and
`blur_hash`; they are `null` until a media processor populates them.

The backend long-poll endpoint, Flutter wait loop, and local media worker are
implemented. The worker claims processing uploads, creates derived assets, and
changes them to `ready` or `failed`. Deploying the worker container remains a
separate task.

### Preview Assets

Media processing will create a derived preview after upload completion:

- Images: resize the original to a bounded JPEG or WebP preview.
- Videos: extract a representative frame, then encode it as the same preview
  image format.
- Store each preview alongside its original under the media-specific storage
  prefix, for example `<user-id>/media/<media-id>/preview.webp`.
- The worker must set media to `processing` while derived assets are created,
  then set it to `ready` only after the preview metadata is persisted. If
  preview generation fails, the item becomes `failed` with a processing error.

The list response should return a short-lived signed `preview_url` for every
ready image and video. The detail response should return the same preview URL
with the signed `media_url` for the original. Gallery cards render a loaded
`preview_url`; while it loads, they render `blur_hash`; and when neither is
available they show the neutral media-type fallback. The video detail view
uses the passed preview as its poster while it loads the ready-only detail
response and initializes the video player.

The preview is a convenience rendition, not a replacement for the original.
Clients must retain the existing fallback UI when no preview URL is available,
which also permits a safe rollout for existing media rows.

### BlurHash

The processing worker should derive a BlurHash from the preview image and store
it with the media row. A single `blur_hash` value works for both images and
videos because video previews are images.

The Flutter client uses the `blurhash` package to render `blur_hash` behind a
network preview while it loads. It should show the same BlurHash as the video
poster placeholder. A neutral surface and media-type icon remain the fallback
for items created before BlurHash support or for a malformed hash.

Do not generate video thumbnails or BlurHashes on the client: decoding a video
there is expensive, platform-dependent, and would require downloading the
original just to populate the gallery. A local pending image may use its picked
bytes for an immediate preview; a pending video uses the normal video fallback
until server processing completes.

### Content Hashes

Use a lowercase hexadecimal SHA-256 hash of the exact original byte sequence.
It is a content identity and deduplication hint, not a perceptual image hash.

The frontend may compute this hash from the selected bytes before initializing
an upload and send it as optional `content_hash`. This avoids a second file read
and can support an early duplicate check, but it is untrusted input. The backend
must independently compute SHA-256 from the stored original during processing,
persist that verified value, and use only the verified value for duplicate
decisions.

The initial API addition should be backward compatible:

```json
{
  "filename": "photo.jpg",
  "mime_type": "image/jpeg",
  "file_size": 12345,
  "content_hash": "optional lowercase SHA-256"
}
```

Expose verified `content_hash`, `preview_url`, and `blur_hash` as nullable
fields in list and detail media responses. The backend must not expose an
unverified client-provided hash as the content identity.

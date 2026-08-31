# Nook

**A calm, personal space for the photos and videos that matter.**

Nook is a privacy-conscious personal media library for uploading, browsing, and
viewing photos and videos across devices.

## Current State

The staging web app is live at https://nook-media.web.app.

The implemented flow supports:

- Email/password sign-in through Supabase Auth
- Authenticated profiles
- Direct-to-Supabase private Storage uploads for supported images and videos
- Media library listing, detail views, deletion, and processing status waits
- Image and video previews, BlurHash placeholders, dimensions, durations, and
  SHA-256 content hashes
- Event-driven background processing after upload verification

After a client uploads an original directly to Supabase Storage, it calls the
backend completion endpoint. The backend verifies the object and starts a
short-lived Cloud Run Job. The job generates a WebP preview and metadata, then
marks the media `ready` or `failed`. The worker is not continuously running.

## Deployed Architecture

- **Flutter web**: Firebase Hosting
- **API**: TypeScript/Hono on Google Cloud Run
- **Media worker**: On-demand Cloud Run Job with `ffmpeg` for video previews
- **Auth, database, and private object storage**: Supabase
- **Runtime secrets**: Google Secret Manager

The public API is available at:

```text
https://nook-api-906436983434.europe-west1.run.app
```

The API accepts only explicit configured browser origins and validates Supabase
bearer tokens before accessing user data.

## Repository Layout

```text
.
├── backend/              # Hono API, Cloud Run images, worker, Supabase schema
│   ├── docs/             # API and media-flow documentation
│   └── supabase/         # Local Supabase config, migrations, and seed data
├── frontend/             # Flutter web and Android client
├── PROJECT_CONTEXT.md    # Product, architecture, and data-model context
└── README.md             # Project overview
```

## Local Development

Use the project-specific READMEs for setup and commands:

- `backend/README.md`: API, local Supabase, tests, and Cloud Run deployment
- `frontend/README.md`: Flutter/FVM setup and local web development
- `backend/docs/media-upload-flow.md`: upload, processing, previews, and
  status-wait lifecycle

Never commit `.env` files or service keys. Local environment files are ignored;
Cloud Run reads its Supabase server key from Secret Manager.

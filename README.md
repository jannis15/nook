# Nook

**A calm, personal space for the photos and videos that matter.**

Nook is a privacy-conscious media library for organizing and accessing personal photos and videos across devices. It is built around ownership, portability, thoughtful design, and the freedom to evolve without being tied permanently to one provider.

The project is in initial setup. The repository currently contains the early backend/frontend foundation, not the full media-library product implementation.

## Direction

Nook starts with one practical product goal: sign in, upload a photo, view it in a gallery, and access it from another device. The current implementation is intentionally earlier than that: it is establishing local Supabase, authentication/profile APIs, tests, and development workflow before media upload work begins.

The intended stack is:

- Flutter for Android and web
- TypeScript and Hono for the backend
- Google Cloud Run for backend deployment
- Supabase Auth, PostgreSQL, Storage, and Row Level Security for the prototype

## Repository Layout

```text
.
├── backend/              # TypeScript/Hono backend scaffold
│   └── supabase/         # Local Supabase config and migrations
├── frontend/             # Flutter app scaffold for Android and web
├── PROJECT_CONTEXT.md    # Product, architecture, and data-model context
└── README.md             # Project overview
```

## Development

Use the project-specific READMEs for setup and local development commands:

- `backend/README.md` for backend dependencies, local Supabase, and database commands
- `frontend/README.md` for Flutter/FVM setup and running the app

## Context

See `PROJECT_CONTEXT.md` for the current product principles, initial scope, architecture direction, and draft data model.

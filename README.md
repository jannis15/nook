# Nook

**A calm, personal space for the photos and videos that matter.**

Nook is a privacy-conscious media library for organizing and accessing personal photos and videos across devices. It is built around ownership, portability, thoughtful design, and the freedom to evolve without being tied permanently to one provider.

The project is in initial setup. The repository currently contains documentation and starter scaffolds, not real product implementation.

## Direction

Nook starts with one practical goal: sign in, upload a photo, view it in a gallery, and access it from another device. That proves the core value before adding richer organization, indexing, processing, or storage migration.

The intended stack is:

- Flutter for Android and web
- TypeScript and Hono for the backend
- Google Cloud Run for backend deployment
- Supabase Auth, PostgreSQL, Storage, and Row Level Security for the prototype

## Repository Layout

```text
.
├── backend/              # TypeScript/Hono backend scaffold
├── frontend/             # Flutter app scaffold for Android and web
├── PROJECT_CONTEXT.md    # Product, architecture, and data-model context
└── README.md             # Project overview
```

## Context

See `PROJECT_CONTEXT.md` for the current product principles, initial scope, architecture direction, and draft data model.

# Project Context

Nook is a privacy-conscious personal media library for photos and videos. It should provide a calm way to upload, view, organize, search, and download personal media across Android and web.

The project is in the initial setup phase. The repository contains scaffolding and documentation, but no real application implementation yet.

## Product Intent

Nook is built around a simple frustration: personal media is often scattered across devices, folders, cloud providers, and ecosystems. The goal is to create one personal space for the media that matters while keeping ownership, portability, and privacy clear.

Nook should not become a social network, enterprise asset manager, or bloated all-in-one cloud platform. It should solve real personal media-library problems in small, useful increments.

## First Product Milestone

The first meaningful product version should allow a user to sign in, upload one photo, view it in a gallery, then sign in on another device and see the same photo there.

That proves the core value before adding indexing, richer organization, background processing, or storage migration.

## Design Principles

- Personal by default: the product should feel private and owned by the user.
- Calm over crowded: media should remain the focus, and features should be added only when they serve the experience.
- Portable data: files and metadata should remain exportable and migratable.
- Privacy-conscious: storage location and processing behavior should be understandable.
- Useful before complete: each version should solve a real problem before expanding scope.

## Product Scope Direction

The product direction includes:

- Authentication
- Photo and video upload
- Cross-device media viewing
- Responsive gallery UI
- Albums or trip-style collections
- Basic metadata capture
- Search and filtering
- Simple duplicate detection using content hashes
- Original file downloads

The product direction should avoid:

- Advanced sharing
- Social feeds or comments
- Collaborative albums
- Large-scale storage optimization
- Provider migration before there is a working prototype

## Architecture Direction

Nook is planned as a Flutter client plus a TypeScript backend.

```text
Flutter Android/Web clients
        |
        v
TypeScript Hono backend on Google Cloud Run
        |
        v
Supabase Auth, PostgreSQL, Storage, and RLS
```

The backend is the application layer between the clients and Supabase. It should own product-specific API behavior, validation, metadata operations, and eventually storage/provider abstraction.

Supabase Storage is acceptable for the prototype and small test libraries. The storage design should avoid unnecessary coupling so object storage can later move to another provider if cost or scale requires it.

## Data Model Draft

### `profiles`

Application-specific user information. `id` references the Supabase auth user.

```text
id
email
display_name
created_at
updated_at
```

### `media`

Metadata and processing state for uploaded files.

```text
id
owner_id
storage_provider
storage_path
original_filename
media_type
mime_type
file_size
content_hash
width
height
duration
captured_at
uploaded_at
processing_status
created_at
updated_at
```

Valid media types:

```text
image
video
```

Valid processing states:

```text
pending
processing
ready
failed
```

### `collections`

Albums, trips, or other user-defined groupings.

```text
id
owner_id
name
description
cover_media_id
started_at
ended_at
created_at
updated_at
```

### `collection_media`

Join table connecting media items to collections. A media item may belong to multiple collections.

```text
collection_id
media_id
position
added_at
```

### `tags`

User-defined tags.

```text
id
owner_id
name
created_at
```

### `media_tags`

Join table connecting tags to media items.

```text
media_id
tag_id
```

## Implementation Notes

- Keep the first product version small and end-to-end before deepening individual subsystems.
- The current implementation phase is backend/frontend foundation work: local Supabase, authentication wiring, profile APIs, tests, and development workflow. Media upload, gallery, collections, tags, and search are future product work, not immediate implementation requirements.
- Prefer simple, explicit data ownership rules. Every user-owned row should be scoped by `owner_id` directly or indirectly.
- Use Row Level Security for database access boundaries.
- Keep storage paths and database metadata aligned so files remain traceable and exportable.
- Treat duplicate detection as a simple content-hash check first, not a perceptual similarity system.
- Model processing state even before advanced background processing exists, so upload and metadata workflows have a clear lifecycle.

## Learning Goals

Nook is also a project for deepening experience with:

- Maintainable Flutter applications
- Consistent web and Android experiences
- TypeScript backend design with Hono
- Object storage trade-offs
- Media and collection modeling
- Upload and processing-state workflows
- Search and indexing design
- Authentication and authorization
- Architecture and cost trade-offs
- Thoughtful UI and UX

## Motivation

Nook follows a broader principle:

> Make digital life better.

For this project, that means reducing noise, improving ownership, and creating software that feels pleasant to use.

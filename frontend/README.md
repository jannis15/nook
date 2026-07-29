# Nook Frontend

Flutter client for Nook, targeting Android and web.

This is currently an initial Flutter shell. Authentication/profile wiring is the near-term focus; upload, gallery, collections, and search are future product work.

## Role

- Provide the media-library interface
- Support sign-in
- Eventually upload media through the backend/API layer
- Eventually display the user's gallery and collections
- Support search, filtering, and original-file downloads over time

## Development

This project uses FVM and pins Flutter in `.fvmrc`.

Use the shared IntelliJ run configuration:

- `frontend/.idea/runConfigurations/main_dart.xml`

It launches `lib/main.dart` on Chrome with web port `3000`.

If the SDK or packages are missing, run `fvm install` and `fvm flutter pub get` from this directory.

## Agent Guidance

`AGENTS.md` contains local conventions for coding agents working in this frontend, such as layering and localization key naming rules.

See `../PROJECT_CONTEXT.md` for product and architecture context.

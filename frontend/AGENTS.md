# agents.md

## Purpose & How to Use This File

- This file defines **non-negotiable rules** for development across repositories.
- If something here conflicts with habit or preference, **this file wins**.
- If a requirement is unclear or underspecified, **ask specific clarification questions before
  acting**.
- Keep this file updated when project context or constraints change.

---

## Project Context & Canonical Documentation

- General rules live in this file.
- Project-specific references live in `AGENT_CONTEXT.md` when present (it may be absent). If it
  exists, read it before making changes and keep it updated.
- Use `AGENT_CONTEXT.md` only for project-specific references (e.g. shared Cubit mixins).
- `README.md` remains the public entry point.
- Flutter/Dart versions are pinned via **FVM** (`.fvmrc`). All commands must use `fvm`.

---

## Repository Structure & Package Management

- Packages follow the standard layout: `lib/`, `test/`, `assets/`.
- Platform folders live at the repo root: `android/`, `ios/`, `web/`.
- Prefer many small files over large files.
- Each page lives in its own file.
- Widgets generally live in their own files; helpers only when truly local.
- Enums and types get their own files unless strictly local.

---

## Layered Architecture & Folder Structure

### Presentation Layer

- Contains presentation logic, theming, routing, pages, localisation, and custom widgets.
- Keep feature-specific presentation code directly in `presentation/<feature>`; do not add a
  `features` folder.
- Feature pages can be nested (e.g. `detail/`, `list/`, `create/`) and may each have their own
  `cubit/` and `widgets/`.
- Presentation entities are **presentation-only** and must never leak into domain or data layers.

📂 presentation
├── 📂 theme
├── 📂 routing
├── 📂 utils
├── 📂 l10n
├── 📂 <feature>
│ ├── 📄 <feature>_page.dart
│ ├── 📄 <feature>_view.dart
│ ├── 📂 cubit
│ │ ├── 📄 <feature>_cubit.dart
│ │ └── 📄 <feature>_state.dart // freezed
│ └── 📂 widgets
└── 📂 widgets
├── 📄 reusable_widget.dart
└── 📂 date_selection
├── 📄 date_selection_cubit.dart
└── 📄 date_selection_state.dart // freezed


---

### Domain Layer

- Contains **business logic only**.
- Must not depend on UI or Data layers.
- Defines contracts and behaviour.

📂 domain
├── 📁 xy
│ ├── 📂 repositories // XyRepository (interfaces only)
│ ├── 📂 use_cases
│ ├── 📂 entities // Xy (domain entities)
│ └── 📂 mappers // Domain ↔︎ Data / UI mapping contracts (optional)

- Use cases:
    - Exactly **one method**: `call()`
    - Constructed in a dedicated provider layer
    - Passed via `BuildContext` into cubits

---

### Data Layer

- Handles **data access**, **models**, **mappers**, and **repository implementations**.
- Depends on domain, never on UI.

📂 data
├── 📁 xy
│ ├── 📁 repositories // Implementations (often suffixed `_implementation`)
│ ├── 📁 models // Data models (optional, sometimes with `/remote`)
│ ├── 📁 mappers // Model ↔︎ Entity mapping (optional)
│ ├── 📁 sources // Optional, with `local/` and/or `remote/`
│ └── 📁 interceptors // Optional (e.g. auth)

- Layer-agnostic utilities live in `lib/utils`.


- Repositories must not expose models outside the data layer.
- Mapping logic must live in **explicit mappers**, never inline in repositories or cubits.
- Use `json_serializable` DTOs for API JSON mapping. Transport classes must use a `Dto` suffix;
  DTO-specific enums are exempt. Repositories and presentation code must not hand-write JSON
  parsing.
- Keep `json_serializable` configured with `field_rename: snake` in `build.yaml` so Dart API
  fields remain camelCase.
- Remote enums using backend `snake_case` values must use
  `@JsonEnum(fieldRename: FieldRename.snake)`.
- Model requiredness must match the current backend contract. The backend is responsible for
  backwards-compatible responses, so do not add frontend fallbacks for omitted required fields.
- Use Dio for API clients. Attach Supabase bearer tokens in a Dio interceptor; repositories must
  not read `currentSession` or set authorisation headers per request.

---

## Tooling, Commands & Automation

### Allowed Without Approval

- Format Dart:
  `fvm dart format -l 120 --set-exit-if-changed $(find lib test -name '*.dart' -not -name '*.freezed.dart' -and -not -name '*.g.dart' -and -not -name 'app_localizations*.dart' -and -not -name '*.gen.dart' -and -not -name '*.gr.dart')`

- Regenerate generated files:
  `fvm dart run build_runner build`

- Generate localisation:
  `fvm flutter gen-l10n`

### Common Development Commands

- Analyze: `fvm dart analyze`
- Test: `fvm flutter test`
- Run app:
  `fvm flutter run --flavor <flavour> -t lib/main_<flavour>.dart`

### Flavours (General Guidance)

- Typical flavours are `local`, `development`, `staging`, and `production`.
- Build modes (`debug`, `profile`, `release`) are separate from flavours.
- Local configuration is supplied through Dart defines from `.env.local`. Never commit secrets;
  commit only `.env.example`.

---

## Architecture, State Management & Data Flow

- **Clean architecture is mandatory**.
- External SDKs live in the data layer. Prefer data sources when present; some repositories wrap
  SDKs directly
  (e.g. push notifications) when a source abstraction is not used.
- State management:
- Use `Cubit`/`Bloc` (flutter_bloc) for app state. Flutter SDK primitives are allowed for local
  widget state only.
- Do not introduce any other state management libraries or patterns.
- Presentation state classes must be public sealed `freezed` classes.
- Always `loading`, `loaded`, `error`
- When a cubit has no meaningful UI state, it may use `Cubit<void>` instead of a freezed state.
- For create/edit forms, keep a dedicated UI edit model in cubit state (for example `FeatureEdit`)
  instead of flattening many individual fields in the loaded state.
- Edit models must support create flow parity by allowing nullable `id` while persisted domain
  entities keep non-null `id`.
- Backend and domain constraints, including supported media extensions and MIME types, belong in
  the domain layer. Presentation code must consume those definitions rather than duplicate them.
- Never use `.when`.
- Prefer exhaustive `switch`.
- Do not wrap `multiple_result` flows in `try/catch`.
- Use `try/catch` **only** at external SDK boundaries.
- Cross-feature refresh/reload must flow through domain-layer repositories/use cases, never by
  calling another feature's Cubit directly.
- Prefer repository-owned canonical streams of domain models/state (for example `watch...` +
  `refresh...`) over generic invalidation signals when a shared read model exists.
- Use one-off non-replaying invalidation signals only when no suitable shared domain read model
  exists and a direct state stream would be disproportionate (for example explicit
  `watch...Invalidations()` + `invalidate...()` flows like payment transactions).
- For cross-feature edit flows, invalidate shared read models/use cases instead of telling other
  pages directly to refresh.
- During migrations/refactors, remove obsolete use cases/providers/streams in the same change.
  Do not leave dead transitional paths behind once the new flow is wired.

---

## Coding Rules (Hard Rules)

- Always add Dart doc comments (`///`) for every public declaration and member, including classes,
  enums, constructors, methods, getters, fields, and extension members.
- Default constructor documentation:
  /// Default constructor.

- TODO format:
  // TODO: <description>

- Never use `var` or `dynamic`.
- Exception: `Map<String, dynamic>` is allowed for JSON object mapping and generated JSON serialization boundaries.
- Prefer `final` and type inference when obvious.
- Never use `!` except inside `DefaultTextStyle`.
- Never bypass null safety.
- Use `??` where possible.
- No constant variables inside `build()`.
- Follow DRY.
- No private methods at file scope.
- No fallback `TextStyle`s.
- Use British (Oxford) English everywhere.
- Prefer method tear-offs (e.g. `onTap: FocusManager.instance.primaryFocus?.unfocus`) over wrapping
  in lambdas when possible.
- Do not use presentation events to trigger UI selection flows (dialogs, sheets, pickers); invoke
  them directly from the view.
- Avoid explicit generic typing for `context.read`/`context.watch` only in Cubit constructor calls;
  elsewhere prefer explicit types.

---

## UI, Widgets & Layout Rules

- One public widget per file, matching file name.
- Others must be private.
- Keep UI files < 300 lines.
- Use `spacing` only when meaningful.
- Never use `SizedBox` solely for spacing.
- Remove unused widgets immediately.
- Reuse widgets aggressively.
- Avoid micro-abstractions.
- Avoid trivial convenience extensions/getters that only forward to a single field; use the original
  property directly instead.
- Avoid pointless widget wrappers; only extract widgets when they add reuse or meaningful UI logic.
- Avoid explicit empty constructors (including `/// Default constructor.` docs) for classes with no
  parameters.
- Do not set `spacing: 0`; omit the property entirely when no spacing is desired.
- List/index screens with a create FAB on mobile must move that primary action next to the page
  title on web using `FilledButton.icon`; do not show a floating FAB on web for that action.
- Create/edit flows that can discard local input must expose an `isDirty` check near the owning
  state/view logic and route both system back and close-button exits through the same discard
  dialog.
- Edit models used in create/edit flows should expose an `.empty()` constructor or factory for
  blank defaults; use that instead of repeating inline empty field values.
- Do not add semantics wrappers or semantic labels to titles.
- Minimise parameters.
- Set `textCapitalization` explicitly on editable text fields where human text is expected
  (for example `sentences` for descriptions/titles, `words` for names/addresses). Keep it unset or
  `none` for technical inputs such as email, phone, URLs, numbers, IDs, search, and read-only
  picker fields.
- For side effects (one-off UI events), use `bloc_presentation` with `BlocPresentationMixin` and a
  dedicated event file.
- Handle those events in the UI via `BlocPresentationListener` (e.g. dialogs, snackbars,
  navigation), not in
  `BlocBuilder` or `build()`.
- Keep form submit actions enabled during validation. Show validation errors only after the user
  attempts to submit. While typing, revalidate only fields that already have an error so that an
  error clears once the field is fixed.
- Name presentation events after domain concepts rather than UI actions.
- Prefer shared Cubit mixins when behaviour is genuinely reusable and improves the UI side (shared
  widgets,
  shared build logic, or consistent affordances). Check `AGENT_CONTEXT.md` for existing mixins first
  and only
  add a new mixin when it reduces duplication. If there is no UI benefit, do not introduce a mixin.
- Private widget methods must:
- Live inside widget or state
- Never return null
- Have visibility logic outside the method
- Minimise work inside `build()`.

---

## Localisation & ARB File Rules

- No hardcoded strings.
- Always use `.arb`.
- Group localisation keys by feature prefix, for example `loginTitle` and `loginSignInButton`.
- Prefix app-wide localisation keys with `app`, for example `appTitle`.
- UI copy must match Figma text 1:1 for the implemented screen/state unless the user explicitly
  approves a wording change.
- Always update all languages.
- German localisation uses informal address (`du`/`dein`), except fixed legal copy such as SEPA
  mandate text.
- Add section tags for new pages/features:
  "@TAG_SELECTION_PAGE": {}

- Insert between sections only.
- Keep keys grouped under their section.
- Keep key order identical across languages.
- Put reusable presentation formatting, including dates and byte sizes, in `presentation/utils`,
  never in page widgets.

---

## Logging, Errors & External SDK Boundaries

- Log key lifecycle events and major operations.
- Logger names must be type-safe:
  Logger((MyClass).toString())

- Always wrap network calls in `try/catch`.
- Do not swallow unexpected exceptions.

---

## Quality Gates, Analysis & MR Checklist

Before finishing any work:

- `fvm dart analyze` must be clean
- Plain tests are discouraged. Prefer behaviour/regression tests with meaningful assertions over trivial mapper/smoke tests that only restate implementation.

### Merge Request Requirements

- Clear description
- Linked ticket
- Screenshots for UI changes
- Testing & impact notes
- No secrets committed

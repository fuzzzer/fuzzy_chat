# FuzzyLink Implementation Prompt

> Copy everything below this line and paste it as your first message in a new AI conversation.

---

## Task: Implement the FuzzyLink Deep Link Feature for Fuzzy Chat

You are implementing a major feature called **FuzzyLink** for the **Fuzzy Chat** Flutter app — an offline-first, local-only encryption app. This feature adds deep link support so users can share invitations, acceptances, and encrypted messages as tappable links instead of manually copy-pasting encrypted text blobs.

### Pre-Resolved Decisions

All design decisions have been finalized. Do NOT ask about these — just use them:

| Decision | Resolution |
|----------|------------|
| URI scheme | **`fuzzylink://`** |
| Deep link package | **`app_links`** (latest stable) |
| GoRouter migration | **Yes — Full migration (Option A).** Replace ALL `Navigator.push` with `go_router`. The app currently has `go_router` in `pubspec.yaml` but it's unused — wire it up now. |
| iOS bundle identifier | **`com.fuzzzytechnologies.fuzzy_chat`** — same as Android |
| Payload expiration | **24 hours** for invitation & acceptance links. **No expiration** for fuzz message links. |
| QR code support | **Deferred to V2.** Do NOT implement QR features. |
| Georgian translations | **Generate placeholder Georgian translations** for all new keys. Mark each with a comment `// TODO: verify translation`. |
| Clipboard detection | **Deferred to V2.** Do NOT implement. |
| Self-destructing messages | **Deferred to V2.** Do NOT implement. |

### Step 1: Read the Project Context

Before writing any code, you MUST read these files in order to understand the project:

1. `.agents/orchestrator.md` — AI workflow rules
2. `.agents/general_app_idea/app_idea.md` — what the app does
3. `.agents/project_guide/project_context.md` — tech stack, dependencies, architecture
4. `.agents/project_guide/architecture_state.md` — current feature status, cubits, repos, navigation
5. `.agents/project_guide/file_tree.md` — complete file structure
6. `.agents/general_guide/flutter_architecture.md` — architecture rules
7. `.agents/general_guide/lessons_learned.md` — past bugs and patterns
8. `.agents/user_context/mindset.md` — how I want you to think
9. `.agents/user_context/preferences.md` — constraints and style

### Step 2: Read the FuzzyLink Feature Plan

The complete plan is in the `/tasks/` directory. Read ALL of these files:

1. `tasks/00_feature_overview.md` — Feature vision, architecture overview, 3 link types, security summary, technology choices
2. `tasks/01_flow_design.md` — Complete user journeys for invitation/acceptance/fuzz links (cold start, warm start, auth integration, edge cases, fallback behavior)
3. `tasks/02_uri_scheme_design.md` — URI format (`fuzzylink://`), payload structures (JSON), Base64URL encoding, compression strategy, version field, hybrid share text format
4. `tasks/03_platform_setup.md` — Android AndroidManifest.xml intent filter, iOS Info.plist CFBundleURLTypes, macOS Info.plist, `app_links` package usage
5. `tasks/04_implementation_phases.md` — 7 phases with exact file paths, code sketches, new/modified file lists, dependency registration, test plan
6. `tasks/05_security_analysis.md` — Threat model (6 attack vectors), mitigations, security implementation checklist
7. `tasks/06_ux_enhancements.md` — Extra ideas — these are ALL DEFERRED to V2, do NOT implement any of them
8. `tasks/07_developer_tasks.md` — All decisions are resolved (see checklist at bottom)

### Step 3: Implementation Rules

Follow these rules strictly:

1. **FVM required** — All Flutter/Dart commands must use `fvm flutter ...` / `fvm dart ...`
2. **100% offline** — No servers, no HTTP, no remote APIs, no network calls. FuzzyLink is just a URI format for data already being shared.
3. **Additive only** — Do NOT remove or modify the existing copy-paste flow. Every screen that gets a "Share as Link" button must KEEP the existing "Copy Fuzz" button.
4. **Reuse existing code** — The `HandshakeService` already generates/parses invitation and acceptance payloads. FuzzyLink wraps these in a URI. Do NOT rewrite crypto logic.
5. **Existing patterns** — Follow the project's established patterns: BLoC/Cubit for state, GetIt for DI, barrel files for exports, `StateStatus` enum for loading states.
6. **Run `exp.sh`** after creating new files to regenerate barrel exports.
7. **Localization** — Add English keys to `app_en.arb`. Add placeholder Georgian keys to `app_ka.arb` with `// TODO: verify translation` comments.
8. **Payload expiration** — Invitation and acceptance link payloads must include an `exp` field (Unix timestamp, 24h from creation). Fuzz message payloads have no expiration. The parser must check expiration and reject expired links with a user-friendly message.

### Step 4: Implementation Order

Execute these phases in order. **All phases are required including GoRouter migration.**

#### Phase 0: Infrastructure
- Add `app_links` to `pubspec.yaml` and run `fvm flutter pub get`
- Create the `lib/src/core/services/fuzzy_link/` directory with all service files:
  - `FuzzyLinkType` enum
  - `FuzzyLinkPayload` sealed class (invitation, acceptance, fuzz subtypes)
  - `FuzzyLinkParser` — parses `fuzzylink://` URIs into typed payloads, validates version, checks expiration
  - `FuzzyLinkGenerator` — generates URIs from existing invitation/acceptance/message data, AND generates hybrid share text (link + raw fuzz fallback), adds `exp` field for invitations/acceptances
  - `FuzzyLinkService` — wraps `AppLinks` for initial link + stream
- Register `FuzzyLinkService` in `dependency_injection.dart`
- Apply platform config: Android `AndroidManifest.xml`, iOS `Info.plist`, macOS `Info.plist`

#### Phase 1: GoRouter Migration
- Create `AppRouter` class with all route definitions
- Replace `MaterialApp` with `MaterialApp.router` in `app.dart`
- Define routes for ALL existing pages:
  - `/` → ChatListPage (or OnboardingPage if first launch)
  - `/chat/create` → ChatCreationPage
  - `/chat/:chatId/invitation` → ChatInvitationPage
  - `/chat/accept` → InvitationAcceptancePage
  - `/chat/:chatId/acceptance-export` → AcceptanceExportPage
  - `/chat/:chatId` → ConnectedChatPage
  - `/settings` → SettingsPage
  - `/auth` → FuzzyUserAuthPage
  - `/basics` → BasicEncryptionPage
- Replace ALL `Navigator.push` / `Navigator.pushReplacement` calls across the codebase with `context.go()` / `context.push()`
- Ensure the existing `navigatorKey` and `scaffoldMessengerKey` are wired into GoRouter
- Test that all existing navigation flows still work exactly as before

#### Phase 2: Deep Link Reception & Routing
- Create `FuzzyLinkHandler` — listens for incoming links, parses them, routes to correct action
- Create `FuzzyLinkListener` widget — hooks into app lifecycle
- Wire into `app.dart` (above the `MaterialApp.router`)
- Handle auth gating: if app is locked, store pending payload, process after auth success
- Use GoRouter for all deep-link-triggered navigation

#### Phase 3: Invitation Links
- Add `getInvitationLink()` to `InvitationReaderCubit`
- Add "Share as Link" button to `ChatInvitationPage` (alongside existing "Copy Fuzz")
- Handle incoming invitation links in `FuzzyLinkHandler` → navigate to `InvitationAcceptancePage` with prefilled content
- Modify `InvitationAcceptancePage` to accept optional `prefillInvitationContent` parameter
- Check expiration — show "This invitation has expired" if `exp` is past

#### Phase 4: Acceptance Links
- Add "Share as Link" button to `AcceptanceExportPage`
- Handle incoming acceptance links in `FuzzyLinkHandler` → find matching chat → complete handshake → navigate to `ConnectedChatPage`
- Handle edge cases: chat not found, already connected, expired link

#### Phase 5: Fuzz Message Links
- Add "Share as Link" option to message bubble context menu in `ConnectedChatPage`
- Handle incoming fuzz message links in `FuzzyLinkHandler` → find chat → decrypt → save as received message → navigate to chat
- Handle edge cases: chat not found, decryption failure, no matching chat

#### Phase 6: Polish
- Add all localization keys (English + placeholder Georgian)
- Write unit tests for `FuzzyLinkParser` and `FuzzyLinkGenerator`
- Write unit tests for expiration logic
- Verify all edge cases from `01_flow_design.md` Section 6
- Update `.agents/project_guide/architecture_state.md` and `.agents/project_guide/file_tree.md` with new files and features
- Run `fvm flutter analyze` and fix all warnings

### Step 5: Key Technical Details

**URI format:**
```
fuzzylink://invite/<base64url_payload>
fuzzylink://accept/<base64url_payload>
fuzzylink://fuzz/<base64url_payload>
```

**Invitation payload (with expiration):**
```json
{"v":1,"t":"inv","I":"<base64_chat_id>","P":"<base64_public_key_json>","exp":1714746460}
```

**Acceptance payload (with expiration):**
```json
{"v":1,"t":"acc","I":"<base64_chat_id>","P":"<base64_public_key_json>","E":"<base64_encrypted_key>","exp":1714746460}
```

**Fuzz message payload (no expiration):**
```json
{"v":1,"t":"fuz","c":"<chat_id>","m":"<encrypted_message>"}
```

**The hybrid share text must always include both link AND raw fuzz:**
```
🔐 Fuzzy Chat Invitation

Tap to connect:
fuzzylink://invite/eyJ2...

────────────────────
Can't tap? Copy and paste into Fuzzy Chat:
{"I":"aGVsbG8t...","P":"eyJuIjoi..."}
```

**Existing files to study before coding:**
- `lib/src/core/encryption_services/handshake_service/handshake_service.dart` — generates/parses invitation and acceptance payloads
- `lib/src/fuzzy_chat/bloc/handshake_cubit/handshake_cubit.dart` — completes handshake from acceptance
- `lib/src/fuzzy_chat/bloc/invitation_acceptance_cubit/invitation_acceptance_cubit.dart` — accepts invitation, generates keys
- `lib/src/fuzzy_chat/bloc/connected_chat_cubit/connected_chat_cubit.dart` — sends/receives messages
- `lib/src/fuzzy_chat/ui/pages/chat_invitation_page/chat_invitation_page.dart` — current invitation UI
- `lib/src/fuzzy_chat/ui/pages/acceptance_export_page/acceptance_export_page.dart` — current acceptance export UI
- `lib/src/app/app.dart` — app entry point with navigatorKey and scaffoldMessengerKey
- `lib/src/core/dependency_injection.dart` — GetIt DI registration

### Start Now

Begin with Phase 0. After each phase, show me what you've created and wait for my approval before proceeding to the next phase. If you encounter any ambiguity, ask me — do not guess.

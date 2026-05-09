# Fuzzy Chat — Architecture State

> This is the living snapshot of the application's implementation. Updated by the [DOCUMENTER] persona after each lifecycle.

---

## 1. Feature Implementation Status

### fuzzy_chat/ (Core Feature)
- [x] **Chat Creation** — `bloc/chat_creation_cubit/`, `ui/pages/chat_creation_page/`
- [x] **Chat List** — `bloc/chat_general_data_list_cubit/`, `ui/pages/chat_list_page/`
- [x] **Connected Chat (Message View)** — `bloc/connected_chat_cubit/`, `ui/pages/connected_chat_page/`
- [x] **Invitation Flow (Sender)** — `bloc/handshake_cubit/`, `ui/pages/chat_invitation_page/`
- [x] **Invitation Acceptance (Receiver)** — `bloc/invitation_acceptance_cubit/`, `ui/pages/invitation_acceptance_page/`
- [x] **Invitation Reader** — `bloc/invitation_reader_cubit/`
- [x] **Acceptance Reader** — `bloc/acceptance_reader_cubit/`
- [x] **Acceptance Export** — `ui/pages/acceptance_export_page/`
- [x] **File Encryption/Decryption** — `bloc/file_processing_cubit/`, `bloc/chat_file_injector_cubit/`
- [x] **Onboarding** — `ui/pages/onboarding_page/`
- [x] **Settings** — `ui/pages/settings_page/`

### fuzzy_auth/ (Auth Feature)
- [x] **User Auth Preferences** — `bloc/fuzzy_user_auth_preferences_cubit/`
- [x] **Auth Store** — `bloc/fuzzy_auth_store/`
- [x] **Auth Page** — `ui/pages/fuzzy_user_auth_page/`

### fuzzy_basics/ (Standalone Encryption)
- [x] **Basic Encryption** — `bloc/basic_encryption_cubit/`, `ui/pages/basic_encryption_page/`
- [x] **Custom File Processing** — `bloc/custom_file_processing_cubit/`

### app/ (App Shell)
- [x] **Theme Management** — `globals/bloc/theme_cubit/`
- [x] **Localization Management** — `globals/bloc/localization_cubit/`
- [x] **Global BLoC Providers** — `globals/global_bloc_providers.dart`
- [x] **Global BLoC Listeners** — `globals/global_bloc_listeners.dart`
- [x] **Bootstrap / AppBlocObserver** — `components/bootstrap.dart`
- [x] **GoRouter Migration** — `app_router.dart` (all Navigator.push → GoRouter)
- [x] **FuzzyLink Listener** — `components/fuzzy_link_listener.dart`

### core/services/fuzzy_link/ (Deep Link Feature)
- [x] **FuzzyLinkService** — `fuzzy_link_service.dart` (app_links wrapper)
- [x] **FuzzyLinkParser** — `fuzzy_link_parser.dart` (URI → typed payload)
- [x] **FuzzyLinkGenerator** — `fuzzy_link_generator.dart` (data → URI string)
- [x] **FuzzyLinkHandler** — `fuzzy_link_handler.dart` (reception, validation, auth gating, routing)
- [x] **FuzzyLinkPayload** — `components/fuzzy_link_payload.dart` (sealed payload classes)
- [x] **FuzzyLinkType** — `components/fuzzy_link_type.dart` (type enum)

---

## 2. Cubit / BLoC Registry

| Cubit | State | Feature | File |
|-------|-------|---------|------|
| `ThemeCubit` | `ThemeState` | app | `lib/src/app/globals/bloc/theme_cubit/` |
| `LocalizationCubit` | `LocalizationState` | app | `lib/src/app/globals/bloc/localization_cubit/` |
| `ChatCreationCubit` | `ChatCreationState` | fuzzy_chat | `lib/src/fuzzy_chat/bloc/chat_creation_cubit/` |
| `ChatGeneralDataListCubit` | `ChatGeneralDataListState` | fuzzy_chat | `lib/src/fuzzy_chat/bloc/chat_general_data_list_cubit/` |
| `ConnectedChatCubit` | `ConnectedChatState` | fuzzy_chat | `lib/src/fuzzy_chat/bloc/connected_chat_cubit/` |
| `HandshakeCubit` | `HandshakeState` | fuzzy_chat | `lib/src/fuzzy_chat/bloc/handshake_cubit/` |
| `InvitationReaderCubit` | `InvitationReaderState` | fuzzy_chat | `lib/src/fuzzy_chat/bloc/invitation_reader_cubit/` |
| `InvitationAcceptanceCubit` | `InvitationAcceptanceState` | fuzzy_chat | `lib/src/fuzzy_chat/bloc/invitation_acceptance_cubit/` |
| `AcceptanceReaderCubit` | `AcceptanceReaderState` | fuzzy_chat | `lib/src/fuzzy_chat/bloc/acceptance_reader_cubit/` |
| `ChatFileInjectorCubit` | `ChatFileInjectorState` | fuzzy_chat | `lib/src/fuzzy_chat/bloc/chat_file_injector_cubit/` |
| `FileProcessingCubit<T>` | `FileProcessingState` | fuzzy_chat | `lib/src/fuzzy_chat/bloc/file_processing_cubit/` |
| `FuzzyAuthStore` | `FuzzyAuthState` | fuzzy_auth | `lib/src/fuzzy_auth/bloc/fuzzy_auth_store/` |
| `FuzzyUserAuthPreferencesCubit` | `FuzzyUserAuthPreferencesState` | fuzzy_auth | `lib/src/fuzzy_auth/bloc/fuzzy_user_auth_preferences_cubit/` |
| `BasicEncryptionCubit` | `BasicEncryptionState` | fuzzy_basics | `lib/src/fuzzy_basics/bloc/basic_encryption_cubit/` |
| `CustomFileProcessingCubit<T>` | — | fuzzy_basics | `lib/src/fuzzy_basics/bloc/custom_file_processing_cubit/` |

---

## 3. Repository Registry

| Repository | Feature | File |
|-----------|---------|------|
| `KeysRepository` | fuzzy_chat | `lib/src/fuzzy_chat/data/repositories/keys_repository/keys_repository.dart` |
| `KeyStorageRepository` | fuzzy_chat | `lib/src/fuzzy_chat/data/repositories/keys_repository/key_storage_repository.dart` |
| `ChatGeneralDataListRepository` | fuzzy_chat | `lib/src/fuzzy_chat/data/repositories/chat_general_data_list_repository/` |
| `MessageDataRepository` | fuzzy_chat | `lib/src/fuzzy_chat/data/repositories/message_data_repository/` |
| `ChatPreferencesRepository` | fuzzy_chat | `lib/src/fuzzy_chat/storage/local_data_sources/chat_preferences_repository.dart` |
| `UserAuthPreferencesRepository` | fuzzy_auth | `lib/src/fuzzy_auth/data/repositories/user_auth_preferences_repository.dart` |

---

## 4. Navigation (GoRouter)

The app uses **GoRouter** via `MaterialApp.router`. All navigation uses `context.push/go/pop()`.
Router instance is cached at `AppRouter.routerInstance` for access from non-widget code (e.g., `FuzzyLinkHandler`).

| Route | Path | Page | Extra |
|-------|------|------|-------|
| `home` | `/` | `OnboardingPage` or `ChatListPage` | — |
| `chatCreate` | `/chat/create` | `ChatCreationPage` | — |
| `chatInvitation` | `/chat/invitation` | `ChatInvitationPage` | `ChatInvitationPagePayload` |
| `chatAccept` | `/chat/accept` | `InvitationAcceptancePage` | `String?` (prefill) |
| `chatAcceptanceExport` | `/chat/acceptance-export` | `AcceptanceExportPage` | `AcceptanceExportPagePayload` |
| `chatConnected` | `/chat/connected` | `ConnectedChatPage` | `ConnectedChatPagePayload` |
| `settings` | `/settings` | `SettingsPage` | — |
| `auth` | `/auth` | `FuzzyUserAuthPage` | — |
| `basics` | `/basics` | `BasicEncryptionPage` | — |

### Deep Link Flow (FuzzyLink)
1. `FuzzyLinkListener` wraps `MaterialApp.router`, initializes `FuzzyLinkHandler` on mount.
2. Handler listens to `FuzzyLinkService.onLinkReceived` stream + checks initial link (cold start).
3. On URI reception → `FuzzyLinkParser.parse()` → validates → auth gating → routes via `AppRouter.routerInstance.push()`.
4. Auth gating: if app is locked, payload queued in `_pendingPayload`; processed after auth via `GlobalBlocListeners`.
5. Security checks: self-invitation detection, duplicate acceptance detection, expiration validation.

---

## 5. Data Storage Map

| Storage | Technology | Purpose |
|---------|-----------|---------|
| Chat data & messages | Isar DB | Local NoSQL for chat data, message history |
| Cryptographic keys | `flutter_secure_storage` | Encrypted keychain for public/private keys |
| User preferences | `shared_preferences` | Onboarding status, theme, locale settings |

---

## 6. Technical Debt & Known Issues

- [x] ~~`go_router` is declared as a dependency but not used~~ — **RESOLVED**: Full GoRouter migration completed.
- [ ] `buildrunner.sh` uses `flutter pub run` (deprecated) — should use `dart run build_runner build --delete-conflicting-outputs`.
- [ ] The general architecture guide references HTTP/API patterns that don't apply to this offline-only app. *(Addressed in project_context.md deviations table)*
- [ ] UI Kit lives inside `lib/src/ui_kit/` rather than as a separate package in `packages/`. The `packages/` directory only contains `pointycastle`.
- [ ] FuzzyLink message deduplication (timestamp/nonce) not yet implemented — recommended for V2.
- [ ] FuzzyLink UX enhancements deferred to V2: QR codes, clipboard detection, self-destructing messages, re-keying.

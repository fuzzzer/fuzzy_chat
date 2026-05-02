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

## 4. Navigation (Current State)

The app currently uses **`Navigator`-based routing** via `MaterialApp` (not GoRouter).

| Page | Feature | Navigation Trigger |
|------|---------|-------------------|
| `OnboardingPage` | fuzzy_chat | Initial route (if `!hasSeenOnboarding`) |
| `ChatListPage` | fuzzy_chat | Initial route (if `hasSeenOnboarding`) |
| `ChatCreationPage` | fuzzy_chat | From ChatList |
| `ChatInvitationPage` | fuzzy_chat | From ChatCreation |
| `InvitationAcceptancePage` | fuzzy_chat | From ChatList (paste invite) |
| `AcceptanceExportPage` | fuzzy_chat | After accepting invitation |
| `ConnectedChatPage` | fuzzy_chat | From ChatList (tap chat) |
| `SettingsPage` | fuzzy_chat | From ChatList |
| `FuzzyUserAuthPage` | fuzzy_auth | Auth flow |
| `BasicEncryptionPage` | fuzzy_basics | Standalone tool |

---

## 5. Data Storage Map

| Storage | Technology | Purpose |
|---------|-----------|---------|
| Chat data & messages | Isar DB | Local NoSQL for chat data, message history |
| Cryptographic keys | `flutter_secure_storage` | Encrypted keychain for public/private keys |
| User preferences | `shared_preferences` | Onboarding status, theme, locale settings |

---

## 6. Technical Debt & Known Issues

- [ ] `go_router` is declared as a dependency but not used — app still uses `Navigator.push`. Consider migrating or removing the dependency.
- [ ] `buildrunner.sh` uses `flutter pub run` (deprecated) — should use `dart run build_runner build --delete-conflicting-outputs`.
- [ ] The general architecture guide references HTTP/API patterns that don't apply to this offline-only app. *(Addressed in project_context.md deviations table)*
- [ ] UI Kit lives inside `lib/src/ui_kit/` rather than as a separate package in `packages/`. The `packages/` directory only contains `pointycastle`.

# Fuzzy Chat — File Tree

> Auto-generated project structure. Updated by the [DOCUMENTER] persona.

```
fuzzy_chat/
├── lib/
│   ├── main.dart
│   ├── main_development.dart
│   ├── main_staging.dart
│   ├── main_production.dart
│   ├── lib.dart                              # Root barrel
│   └── src/
│       ├── src.dart                           # Feature barrel
│       │
│       ├── app/                               # App Shell
│       │   ├── app.dart                       # App widget + runner
│       │   ├── initializer.dart               # Pre-app initialization
│       │   ├── components/
│       │   │   ├── bootstrap.dart             # AppBlocObserver + bootstrap()
│       │   │   └── components.dart
│       │   └── globals/
│       │       ├── globals.dart
│       │       ├── global_bloc_providers.dart
│       │       ├── global_bloc_listeners.dart
│       │       └── bloc/
│       │           ├── bloc.dart
│       │           ├── theme_cubit/
│       │           │   ├── theme_cubit.dart
│       │           │   ├── theme_state.dart
│       │           │   └── components/
│       │           │       ├── chosen_brightness.dart
│       │           │       └── components.dart
│       │           └── localization_cubit/
│       │               ├── localization_cubit.dart
│       │               └── localization_state.dart
│       │
│       ├── core/                              # Core Layer
│       │   ├── core.dart
│       │   ├── dependency_injection.dart       # GetIt DI setup
│       │   ├── candy_tools/                   # BLoC state enums
│       │   │   ├── candy_tools.dart
│       │   │   ├── state_status.dart
│       │   │   ├── filter_state_status.dart
│       │   │   ├── optimistic_update_status.dart
│       │   │   └── action_type.dart
│       │   ├── encryption_services/           # Cryptography layer
│       │   │   ├── encryption_services.dart
│       │   │   ├── aes_service/
│       │   │   │   ├── aes_service.dart
│       │   │   │   ├── aes_service_impl.dart
│       │   │   │   └── components/
│       │   │   │       ├── components.dart
│       │   │   │       ├── file_encryption_isolate_arguments.dart
│       │   │   │       ├── file_processing_handler.dart
│       │   │   │       └── file_processing_progress.dart
│       │   │   ├── rsa_service/
│       │   │   │   ├── rsa_service.dart
│       │   │   │   └── rsa_service_impl.dart
│       │   │   ├── handshake_service/
│       │   │   │   ├── handshake_service.dart
│       │   │   │   └── components/
│       │   │   │       ├── components.dart
│       │   │   │       ├── recieved_acceptance.dart
│       │   │   │       ├── recieved_invitation.dart
│       │   │   │       ├── to_be_sent_acceptance.dart
│       │   │   │       └── to_be_sent_invitation.dart
│       │   │   └── password_based_encryption_service/
│       │   │       ├── password_based_encryption_service.dart
│       │   │       └── password_based_encryption_service_impl.dart
│       │   ├── error_handling/
│       │   │   ├── error_handling.dart
│       │   │   ├── default_failure.dart
│       │   │   └── ui_failures/
│       │   │       ├── ui_failures.dart
│       │   │       └── chat_creation_failure/
│       │   │           ├── chat_creation_failure.dart
│       │   │           ├── chat_creation_failure_type.dart
│       │   │           └── components.dart
│       │   ├── services/
│       │   │   ├── services.dart
│       │   │   ├── service_locator/
│       │   │   │   ├── service_locator.dart
│       │   │   │   └── impl/
│       │   │   │       ├── impl.dart
│       │   │   │       └── service_locator_getit.dart
│       │   │   ├── preferences_service/
│       │   │   │   └── preferences_service.dart
│       │   │   ├── fuzzy_hub/
│       │   │   │   └── fuzzy_hub.dart
│       │   │   └── directory_assets/
│       │   │       ├── directory_assets.dart
│       │   │       ├── app_documents_directory.dart
│       │   │       └── app_support_directory.dart
│       │   ├── l10n/
│       │   │   ├── l10n.dart
│       │   │   ├── current_context_localizations.dart
│       │   │   ├── supported_locales.dart
│       │   │   └── generated_localizations/
│       │   │       ├── generated_localizations.dart
│       │   │       ├── fuzzy_chat_localizations.dart
│       │   │       ├── fuzzy_chat_localizations_en.dart
│       │   │       └── fuzzy_chat_localizations_ka.dart
│       │   ├── constants/
│       │   │   ├── constants.dart
│       │   │   └── default_constants.dart
│       │   ├── utils/
│       │   │   ├── utils.dart
│       │   │   ├── copy_guard.dart
│       │   │   ├── debouncer.dart
│       │   │   ├── file_reader.dart
│       │   │   ├── id_generator.dart
│       │   │   ├── logger.dart
│       │   │   ├── map_casting.dart
│       │   │   ├── reveal_file.dart
│       │   │   └── secure_bytes_generation.dart
│       │   └── extensions/
│       │       ├── extensions.dart
│       │       ├── build_context_extension.dart
│       │       └── first_where_or_null_extension.dart
│       │
│       ├── fuzzy_chat/                        # Core Feature
│       │   ├── fuzzy_chat.dart
│       │   ├── bloc/
│       │   │   ├── bloc.dart
│       │   │   ├── chat_creation_cubit/
│       │   │   ├── chat_general_data_list_cubit/
│       │   │   ├── connected_chat_cubit/
│       │   │   ├── handshake_cubit/
│       │   │   ├── invitation_reader_cubit/
│       │   │   ├── invitation_acceptance_cubit/
│       │   │   ├── acceptance_reader_cubit/
│       │   │   ├── chat_file_injector_cubit/
│       │   │   └── file_processing_cubit/
│       │   │       └── components/
│       │   ├── data/
│       │   │   ├── data.dart
│       │   │   ├── models/
│       │   │   │   ├── models.dart
│       │   │   │   └── enums/
│       │   │   └── repositories/
│       │   │       ├── repositories.dart
│       │   │       ├── keys_repository/
│       │   │       │   ├── keys_repository.dart
│       │   │       │   └── key_storage_repository.dart
│       │   │       ├── message_data_repository/
│       │   │       │   ├── message_data_repository.dart
│       │   │       │   └── events/
│       │   │       └── chat_general_data_list_repository/
│       │   │           ├── chat_general_data_list_repository.dart
│       │   │           └── events/
│       │   ├── storage/
│       │   │   ├── storage.dart
│       │   │   ├── storage_models/
│       │   │   │   ├── storage_models.dart
│       │   │   │   ├── stored_chat_general_data.dart (+.g.dart)
│       │   │   │   ├── stored_chat_preferences.dart (+.g.dart)
│       │   │   │   ├── stored_chat_security_data.dart (+.g.dart)
│       │   │   │   └── stored_message_data.dart (+.g.dart)
│       │   │   └── local_data_sources/
│       │   │       ├── local_data_sources.dart
│       │   │       ├── chat_general_data_local_data_source.dart
│       │   │       ├── chat_preferences_local_data_source.dart
│       │   │       ├── chat_preferences_repository.dart
│       │   │       ├── chat_security_data_local_data_source.dart
│       │   │       └── message_data_local_data_source.dart
│       │   └── ui/
│       │       ├── ui.dart
│       │       ├── pages/
│       │       │   ├── pages.dart
│       │       │   ├── onboarding_page/
│       │       │   ├── chat_list_page/
│       │       │   │   └── widgets/ → contents/
│       │       │   ├── chat_creation_page/
│       │       │   ├── chat_invitation_page/
│       │       │   ├── invitation_acceptance_page/
│       │       │   ├── acceptance_export_page/
│       │       │   ├── connected_chat_page/
│       │       │   └── settings_page/
│       │       └── widgets/
│       │           ├── widgets.dart
│       │           ├── chat_deletion_dialog.dart
│       │           ├── bloc_builders/
│       │           └── file_processing_progresses_displays/
│       │
│       ├── fuzzy_auth/                        # Auth Feature
│       │   ├── fuzzy_auth.dart
│       │   ├── bloc/
│       │   │   ├── fuzzy_auth_store/
│       │   │   └── fuzzy_user_auth_preferences_cubit/
│       │   ├── data/
│       │   │   ├── models/ (auth_data, user_auth_preferences)
│       │   │   └── repositories/ (user_auth_preferences_repository)
│       │   ├── storage/
│       │   │   ├── storage_models/ (stored_user_auth_preferences)
│       │   │   └── local_data_sources/
│       │   └── ui/
│       │       └── pages/fuzzy_user_auth_page/
│       │
│       ├── fuzzy_basics/                      # Standalone Encryption
│       │   ├── fuzzy_basics.dart
│       │   ├── bloc/
│       │   │   ├── basic_encryption_cubit/
│       │   │   └── custom_file_processing_cubit/
│       │   ├── core/ (consts)
│       │   ├── data/
│       │   └── ui/
│       │       └── pages/basic_encryption_page/
│       │
│       └── ui_kit/                            # Design System
│           ├── ui_kit.dart
│           ├── colors/
│           │   └── ui_kit_colors.dart
│           ├── text_styles/
│           │   └── ui_kit_text_styles.dart
│           ├── themes/
│           │   ├── ui_kit_theme.dart
│           │   └── theme_extensions/
│           │       ├── ui_colors.dart
│           │       └── ui_text_styles.dart
│           └── widgets/
│               ├── widgets.dart
│               ├── fuzzy_scaffold.dart
│               ├── fuzzy_header.dart
│               ├── fuzzy_textfield.dart
│               ├── fuzzy_toolbox.dart
│               ├── buttons/
│               │   ├── fuzzy_button.dart
│               │   ├── fuzzy_back_button.dart
│               │   ├── fuzzy_bottom_actions.dart
│               │   ├── fuzzy_icon_container_button.dart
│               │   └── text_action.dart
│               ├── file_managers/
│               │   ├── file_drop_area.dart
│               │   └── file_selector_widget.dart
│               ├── overlays/
│               │   ├── fuzzy_overlay_spawner.dart
│               │   └── popups.dart
│               └── status_widgets/
│                   ├── pages/ (fuzzy_error_page_builder, fuzzy_loading_page_builder)
│                   ├── widgets/ (default_loading_widget)
│                   └── fuzzy_snackbar/
│
├── packages/
│   └── pointycastle/                          # Local cryptography fork
│
├── scripts/
│   ├── exporter.py                            # Barrel file generator
│   ├── add_localizations.py                   # L10n helper
│   └── merge_contents.py                      # Content merger for AI context
│
├── code_generators/bricks/                    # Mason templates
├── test/
├── assets/
│
├── exp.sh                                     # → runs exporter.py (barrel files)
├── loc.sh                                     # → runs add_localizations.py
├── m.sh                                       # → runs merge_contents.py (AI context dump)
├── buildrunner.sh                             # → runs build_runner
│
├── pubspec.yaml
├── analysis_options.yaml
├── l10n.yaml
├── GEMINI.md
└── CLAUDE.md
```

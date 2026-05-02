# Fuzzy Chat — Lessons Learned (Long-Term AI Memory)

> This document contains hard-won knowledge from past bugs and architectural decisions. The [DOER] and [REVIEWER] personas MUST consult this file before any action to avoid repeating historical mistakes.

---

## Resolved Anti-Patterns

### AP-001: Never Throw from Repositories
**Problem:** Repositories throwing exceptions force cubits to use try/catch, leading to inconsistent error handling and forgotten catch blocks.
**Resolution:** Repositories return sealed class responses (`Success | Failure`). Cubits use exhaustive `switch`. No try/catch in BLoC layer.
**Rule:** If you write try/catch in a Cubit, you are violating the architecture.

### AP-002: Never Use Service Locator in Repositories or Cubits
**Problem:** Accessing dependencies via `sl.get<T>()` everywhere hides dependencies and makes testing impossible.
**Resolution:** Only local data sources may access `sl` directly (for DB/storage instances). Repositories receive data sources via constructor injection. Cubits receive repositories via constructor injection.
**Rule:** Constructor injection for repos and cubits. Service locator only at data source boundary.

### AP-003: Never Import Feature Files Directly
**Problem:** Importing `package:fuzzy_chat/src/fuzzy_chat/data/models/some_model.dart` creates tight coupling.
**Resolution:** Always import through root barrel: `import 'package:fuzzy_chat/src/src.dart';`
**Rule:** One import. `import 'package:fuzzy_chat/src/src.dart';` is the only project import you write.

### AP-004: Never Skip Barrel Files
**Problem:** Missing barrel exports cause "undefined" errors.
**Resolution:** Every directory has a barrel file. Every new `.dart` file gets exported in its parent barrel immediately.
**Rule:** After file creation, the user must be prompted to run `./exp.sh`.

### AP-005: Never Hardcode Colors, Text Styles, or Spacing
**Problem:** Hardcoded values make theme changes impossible and lead to inconsistency.
**Resolution:** Use theme extensions: `context.uiColors`, `context.uiTextStyles`.
**Rule:** If you type `Color(`, `TextStyle(`, or a magic number for padding, you are violating the architecture.

### AP-006: Never Introduce Network Dependencies
**Problem:** Fuzzy Chat is designed as a 100% offline, zero-server encryption tool. Network dependencies break the security model.
**Resolution:** All data operations use local storage (Isar, SecureStorage, SharedPreferences, file system). Encrypted outputs are shared via external channels by the user.
**Rule:** If you import `dio`, `http`, or any networking package, you are violating the architecture.

---

## Historical Bugs & Fixes

### BUG-001: Safe Registration Required for GetIt
**Context:** Standard `GetIt.registerSingleton<T>()` throws if already registered (common during hot restarts or in test setups).
**Fix:** Use the custom `safeRegisterSingleton` / `safeRegisterLazySingleton` extensions that internally check `sl.isRegistered<T>()`.
**Lesson:** Always use the `safe*` registration variants provided in the project.

---

## Framework Nuances & Best Practices

### FN-001: Dart 3 Sealed Classes for Repository Responses
**Nuance:** Sealed classes are the backbone of our error handling. They enable compile-time safety via exhaustive `switch` statements. Adding a new failure type will cause a compile error wherever it's not handled.
**Pro-Tip:** Embrace this. When adding a new failure case, add it to the sealed hierarchy and let the compiler guide you to all the places that need to be updated.

### FN-002: `part of` Directive for Cubit State
**Nuance:** State files use the `part of 'my_cubit.dart';` directive. This means the state file is lexically part of the cubit file; it can access the cubit's imports but cannot have its own `import` statements.
**Pro-Tip:** All necessary imports for the state must be placed in the main cubit file.

### FN-003: Isar Schema Changes Require Build Runner
**Nuance:** Isar storage models (`stored_*.dart`) have corresponding `.g.dart` generated files. After any change to these models, `./buildrunner.sh` must be run to regenerate the schema adapters.
**Pro-Tip:** Always check if your changes touch `storage/storage_models/` — if so, remind the user to run `./buildrunner.sh`.

### FN-004: Cryptographic Operations May Be CPU-Intensive
**Nuance:** AES file encryption/decryption can block the UI thread for large files. The `AesService` uses isolates (via `FileProcessingHandler`) to offload this work.
**Pro-Tip:** Always use the isolate-based file processing for anything beyond small text encryption. Check `FileEncryptionIsolateArguments` and `FileProcessingProgress` for the pattern.

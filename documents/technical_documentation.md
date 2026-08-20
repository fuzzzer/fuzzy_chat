
## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Fuzzy Chat works on iOS, Android, Mac, and Windows and Possibly on Linux

---

## Developing against a local `fuzzy_design` checkout

`fuzzzy_ui_kit` (from the [fuzzy_design](https://github.com/fuzzzy-bot/fuzzy_design) repo) is pinned in `pubspec.yaml` as a **git** dependency, so a plain `flutter pub get` works for everyone — no local `fuzzy_design` checkout required.

If you're actively changing `fuzzy_design` and want fuzzy_chat to pick up your local edits immediately (no commit/push/re-pin loop), clone it as a sibling of this repo and add a local override:

```sh
# from the parent directory of fuzzy_chat
$ git clone https://github.com/fuzzzy-bot/fuzzy_design.git
```

```yaml
# fuzzy_chat/pubspec_overrides.yaml  (create this file — it's git-ignored, never commit it)
dependency_overrides:
  fuzzzy_ui_kit:
    path: ../fuzzy_design
```

```sh
$ flutter pub get
```

Delete `pubspec_overrides.yaml` (or just don't create one) to go back to the pinned git version. When you want fuzzy_chat's pinned kit version to move forward, push your `fuzzy_design` changes, then update the `ref:` under `fuzzzy_ui_kit` in `pubspec.yaml` to the new commit hash and run `flutter pub get` again.

---

## Android: "Java home supplied is invalid"

`android/gradle.properties` does **not** set `org.gradle.java.home` — that's an absolute path to a JDK install, which differs per machine and doesn't belong in a committed file. If you hit an error like:

```
Value '...' given for org.gradle.java.home Gradle property is invalid (Java home supplied is invalid)
```

set it in your own **global** Gradle config instead (never committed, applies to every Gradle project on your machine):

```sh
# ~/.gradle/gradle.properties
org.gradle.java.home=/path/to/your/jdk-17
```

This project needs JDK 17. On macOS with Homebrew: `brew install openjdk@17`, then point `org.gradle.java.home` at `$(brew --prefix openjdk@17)/libexec/openjdk.jdk/Contents/Home`.

---
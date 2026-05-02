# Fuzzy Chat — Scripts Reference

> Quick reference for all available project scripts. AI personas should use these instead of manual operations.

---

## Shell Scripts (Project Root)

### `./exp.sh` — Barrel File Generator
**When to use:** After creating any new `.dart` file.  
**What it does:** Runs `scripts/exporter.py` to regenerate all barrel files in `lib/src/`.  
**Usage:**
```bash
./exp.sh
```

### `./loc.sh` — Localization Helper
**When to use:** When adding user-facing strings.  
**What it does:** Runs `scripts/add_localizations.py` to add entries to ARB files.  
**Usage:**
```bash
./loc.sh "key||en||English text"
```

### `./m.sh` — Content Merger (AI Context Dump)
**When to use:** When you need to dump a directory's content into a single text file for AI context.  
**What it does:** Runs `scripts/merge_contents.py` to merge all files in a path into `scripts/outputs/<target>.txt`.  
**Usage:**
```bash
./m.sh lib/src/fuzzy_chat       # Merge and output
./m.sh lib/src/fuzzy_chat -c    # Merge and copy to clipboard
```

### `./buildrunner.sh` — Build Runner
**When to use:** After modifying Isar storage models (`*.dart` files in `storage/storage_models/`).  
**What it does:** Runs `flutter pub run build_runner build --delete-conflicting-outputs`.  
**Usage:**
```bash
./buildrunner.sh
```
> ⚠️ Note: This script uses the deprecated `flutter pub run` command. Consider updating to `dart run build_runner build --delete-conflicting-outputs`.

---

## FVM (Flutter Version Manager)

The project uses FVM. **Always prefix Flutter/Dart commands with `fvm`:**
```bash
fvm flutter analyze
fvm flutter test
fvm dart format --set-exit-if-changed .
fvm flutter pub get
```

Current Flutter version: `3.24.3` (see `.fvm/fvm_config.json`)

---

## Python Scripts (scripts/)

| Script | Purpose |
|--------|---------|
| `exporter.py` | Auto-generates barrel files for `lib/src/` |
| `add_localizations.py` | Adds localization entries to ARB files |
| `merge_contents.py` | Merges directory contents into a single text file |

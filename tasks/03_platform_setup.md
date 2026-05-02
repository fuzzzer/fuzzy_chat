# 📱 Platform Setup Guide

> Native configuration required for each platform to support the `fuzzylink://` custom URI scheme.

---

## 1. Android Configuration

### AndroidManifest.xml

Add an `<intent-filter>` for the custom scheme inside the existing `<activity>` tag:

**File:** `android/app/src/main/AndroidManifest.xml`

```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTask"
    ...existing attributes...>

    <!-- Existing launcher intent filter -->
    <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>

    <!-- NEW: FuzzyLink deep link handler -->
    <intent-filter android:autoVerify="false">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="fuzzylink" />
    </intent-filter>
</activity>
```

**Key points:**
- `android:autoVerify="false"` — we're using a custom scheme, not HTTP app links
- `android:launchMode="singleTask"` — already set! This is critical for warm-start deep links (prevents creating a new Activity)
- The `<data>` element only specifies `scheme` — all paths (`/invite`, `/accept`, `/fuzz`) are handled by the Flutter routing layer

### No Additional Android Setup Needed

Since we're using a custom scheme (not `https://`), we do NOT need:
- ❌ `assetlinks.json` digital asset links file
- ❌ Domain verification
- ❌ Any server-side hosting

---

## 2. iOS Configuration

### Info.plist — URL Scheme Registration

**File:** `ios/Runner/Info.plist`

Add the following keys inside the `<dict>`:

```xml
<!-- FuzzyLink Custom URL Scheme -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.fuzzzytechnologies.fuzzy_chat</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fuzzylink</string>
        </array>
        <key>CFBundleTypeRole</key>
        <string>Viewer</string>
    </dict>
</array>
```

**Key points:**
- `CFBundleURLName` should match the bundle identifier
- `CFBundleTypeRole` = `Viewer` means the app views/processes this data (not an Editor)
- This registers the `fuzzylink://` scheme so iOS knows to route these URLs to our app

### No Additional iOS Setup Needed

Since we're using a custom scheme:
- ❌ No Apple App Site Association (AASA) file needed
- ❌ No domain verification
- ❌ No Associated Domains entitlement needed

---

## 3. macOS Configuration

### Info.plist — URL Scheme Registration

**File:** `macos/Runner/Info.plist`

Add the same `CFBundleURLTypes` entry:

```xml
<!-- FuzzyLink Custom URL Scheme -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.fuzzzytechnologies.fuzzy_chat</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fuzzylink</string>
        </array>
        <key>CFBundleTypeRole</key>
        <string>Viewer</string>
    </dict>
</array>
```

---

## 4. Web Configuration

Web doesn't have native deep link handling, but we can support **URL parameters** for the web version:

### Approach: Query Parameter Fallback

When sharing from web, generate a web-compatible URL:
```
https://fuzzychat.app/link?type=invite&payload=eyJ2IjoxLC...
```

When the web app loads, check `window.location` for these query parameters and process them.

### Important: Web is a future enhancement

For the initial implementation, focus on **Android, iOS, and macOS**. Web support can be added later since:
- Web users can still copy/paste (existing flow)
- Web deep link support requires hosting a domain
- The web app is not the primary target for this offline-first tool

---

## 5. Windows & Linux

Custom URL schemes on Windows and Linux are possible but require:
- Windows: Registry entries
- Linux: `.desktop` file and `xdg-open` handler

**Recommendation:** Defer these platforms. Desktop users can continue using copy-paste. The deep link feature primarily benefits mobile users who frequently switch between apps.

---

## 6. Flutter Package: `app_links`

### Why `app_links`?

| Feature | `uni_links` (deprecated) | `app_links` | Custom Platform Channels |
|---------|--------------------------|-------------|-------------------------|
| Maintenance | ❌ Archived | ✅ Active | ✅ You control |
| Android support | ✅ | ✅ | Manual |
| iOS support | ✅ | ✅ | Manual |
| macOS support | ⚠️ Limited | ✅ | Manual |
| Windows support | ❌ | ✅ | Manual |
| Linux support | ❌ | ✅ | Manual |
| Web support | ❌ | ✅ | Manual |
| Cold start link | ✅ | ✅ | Manual |
| Warm start stream | ✅ | ✅ | Manual |

### Installation

Add to `pubspec.yaml`:
```yaml
dependencies:
  app_links: ^6.4.0   # or latest stable
```

### Basic Usage Pattern

```dart
import 'package:app_links/app_links.dart';

class FuzzyLinkService {
  final AppLinks _appLinks = AppLinks();

  /// Call once during app initialization
  Future<Uri?> getInitialLink() async {
    return _appLinks.getInitialLink();
  }

  /// Stream of links received while app is running
  Stream<Uri> get onLinkReceived => _appLinks.uriLinkStream;
}
```

---

## 7. Testing Deep Links

### Android (via ADB)

```bash
# Test invitation link (cold start)
adb shell am start -a android.intent.action.VIEW \
  -d "fuzzylink://invite/eyJ2IjoxLC..." \
  com.fuzzzytechnologies.fuzzy_chat

# Test while app is running (warm start)
adb shell am start -a android.intent.action.VIEW \
  -d "fuzzylink://fuzz/eyJ2IjoxLC..." \
  com.fuzzzytechnologies.fuzzy_chat
```

### iOS (via xcrun)

```bash
# Open URL in simulator
xcrun simctl openurl booted "fuzzylink://invite/eyJ2IjoxLC..."
```

### macOS

```bash
# Open URL on macOS
open "fuzzylink://invite/eyJ2IjoxLC..."
```

---

## 8. Platform Configuration Checklist

| Platform | Config File | What to Add | Status |
|----------|-------------|-------------|--------|
| Android | `AndroidManifest.xml` | `<intent-filter>` with `fuzzylink` scheme | ⬜ TODO |
| iOS | `ios/Runner/Info.plist` | `CFBundleURLTypes` with `fuzzylink` scheme | ⬜ TODO |
| macOS | `macos/Runner/Info.plist` | `CFBundleURLTypes` with `fuzzylink` scheme | ⬜ TODO |
| Web | N/A (handled in Dart) | Query parameter parsing | ⬜ Deferred |
| Windows | Registry | Desktop handler | ⬜ Deferred |
| Linux | `.desktop` file | `xdg-open` handler | ⬜ Deferred |
| Flutter | `pubspec.yaml` | `app_links` dependency | ⬜ TODO |

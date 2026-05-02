# 👤 Developer Tasks — Manual Steps & Decisions Required

> These are tasks that require YOUR direct involvement — decisions, account setups, testing, or configurations that cannot be automated by AI.

---

## 🔴 Critical (Blocking — Must Do Before Development)

### Task 1: Choose the Custom URI Scheme Name

**Decision needed:** Is `fuzzylink` the right scheme name?

**Considerations:**
- `fuzzylink` — clear, branded, descriptive
- `fuzzychat` — matches app name
- `fzchat` — shorter (better for SMS)
- `fz` — very short but might collide

**Current choice:** `fuzzylink`

**Action:** Confirm or suggest an alternative. This decision affects every file in the project.

---

### Task 2: Decide on `app_links` vs Custom Platform Channels

**Decision needed:** Use the `app_links` Flutter package or write custom platform channel code?

**Trade-offs:**

| Factor | `app_links` package | Custom Platform Channels |
|--------|--------------------|-----------------------|
| Development time | ✅ Fast (~1 day) | ⚠️ Slow (~1 week) |
| Maintenance | ✅ Community maintained | ⚠️ You maintain |
| Dependencies | ⚠️ +1 dependency | ✅ Zero dependencies |
| Control | ⚠️ Less control | ✅ Full control |
| Platform coverage | ✅ All platforms | You build each platform |

**Recommendation:** Use `app_links` for V1. Migrate to custom channels later if needed.

**Action:** Approve or reject.

---

### Task 3: Decide on GoRouter Migration Scope

**Decision needed:** Should we migrate to GoRouter as part of this feature?

**Options:**

| Option | Description | Risk |
|--------|-------------|------|
| A. Full migration | Replace all `Navigator.push` with GoRouter | 🟡 Medium — larger scope but cleaner result |
| B. Partial migration | Use GoRouter only for deep link routes, keep Navigator for rest | 🟡 Medium — two routing systems coexist |
| C. No migration | Handle deep links with Navigator only | 🟢 Low — smallest scope, but misses opportunity |

**Recommendation:** Option A (full migration) — GoRouter is already in `pubspec.yaml` and deep link support is a great reason to finally wire it up.

**Action:** Choose A, B, or C.

---

## 🟡 Important (Required During Development)

### Task 4: iOS Bundle Identifier Confirmation

**Current:** `com.fuzzzytechnologies.fuzzy_chat` (from AndroidManifest.xml)

**Needed for:** `CFBundleURLName` in Info.plist

**Action:** Confirm this matches the iOS bundle identifier configured in Xcode.

**How to check:**
```bash
# From project root:
grep -r "PRODUCT_BUNDLE_IDENTIFIER" ios/
```

---

### Task 5: Test Deep Links on Physical Devices

**Why:** Deep links behave differently on simulators vs real devices, especially:
- iOS: Custom URL schemes may not work on some simulator versions
- Android: Intent filters need to be tested with the actual installed app
- macOS: URL scheme registration requires app restart

**Action:** Test the following on real devices:

| Test | Device | Passed? |
|------|--------|---------|
| Tap invitation link in SMS → app opens | Android phone | ⬜ |
| Tap invitation link in SMS → app opens | iPhone | ⬜ |
| Tap invitation link while app is open | Android phone | ⬜ |
| Tap invitation link while app is open | iPhone | ⬜ |
| Tap fuzz link → message decrypts | Android phone | ⬜ |
| Tap fuzz link → message decrypts | iPhone | ⬜ |
| Tap link when app is locked (auth) | Both | ⬜ |
| Tap link for deleted chat | Both | ⬜ |
| Open fuzzylink:// in macOS Terminal | Mac | ⬜ |

---

### Task 6: Add Georgian Translations

**New localization keys needed:**

| Key | English | Georgian (needs translation) |
|-----|---------|-----|
| `shareAsLink` | Share as Link | ⬜ |
| `shareAsText` | Share as Text | ⬜ |
| `incomingInvitation` | Incoming invitation detected | ⬜ |
| `processInvitation` | Would you like to process it? | ⬜ |
| `connectionComplete` | Connection established! | ⬜ |
| `invalidLink` | This link is invalid or corrupted | ⬜ |
| `noMatchingChat` | No matching chat found | ⬜ |
| `alreadyConnected` | Already connected! | ⬜ |
| `updateRequired` | Please update Fuzzy Chat | ⬜ |
| `cantAcceptOwnInvitation` | You can't accept your own invitation | ⬜ |
| `linkExpired` | This link has expired | ⬜ |
| `tapToConnect` | Tap to connect securely | ⬜ |
| `chatInvitationTitle` | Fuzzy Chat Invitation | ⬜ |
| `chatAcceptanceTitle` | Fuzzy Chat Acceptance | ⬜ |
| `encryptedMessageTitle` | Encrypted Message | ⬜ |
| `fallbackPasteHint` | Can't tap? Copy and paste into Fuzzy Chat | ⬜ |

**Action:** Provide Georgian translations for these keys, or confirm that AI-generated translations are acceptable for now.

---

### Task 7: App Icon / Launch Screen Update

**Consideration:** When a user taps a FuzzyLink, the app launches with whatever splash screen is currently configured. 

**Action:** Verify that the current launch screen and app icon look good for the "first impression" moment when a user taps a link and the app opens.

---

## 🟢 Nice to Have (Can Be Done Anytime)

### Task 8: Choose Payload Expiration Duration

**Decision needed:** How long should invitation/acceptance links remain valid?

**Options:**
| Duration | Pros | Cons |
|----------|------|------|
| 1 hour | Maximum security | Users may miss the window |
| 24 hours | Good balance | Most common for link expiry |
| 7 days | Very forgiving | Larger replay attack window |
| No expiration | Simplest | Unlimited replay window |

**Recommendation:** 24 hours for invitations, 24 hours for acceptances, no expiration for fuzz messages.

**Action:** Confirm or adjust.

---

### Task 9: Decide on QR Code Support (Enhancement)

**Decision needed:** Should QR code exchange be part of V1 or deferred to V2?

If included in V1, additional packages needed:
- `qr_flutter` — QR generation
- `mobile_scanner` — QR scanning

**Recommendation:** Defer to V2. Deep links alone provide massive UX improvement. QR codes can be added in a follow-up release.

**Action:** Include in V1 or defer?

---

### Task 10: Privacy Policy / App Store Description Update

**If Fuzzy Chat is distributed via app stores:**

- Update the App Store description to mention the new deep link feature
- Ensure the privacy policy covers URL scheme handling (no data is collected or transmitted)
- Mention that the app processes `fuzzylink://` URLs

**Action:** Update store listing and privacy policy when the feature ships.

---

## 📋 Summary Checklist

| # | Task | Type | Status | Resolution |
|---|------|------|--------|------------|
| 1 | Confirm URI scheme name (`fuzzylink`) | Decision | ✅ | **`fuzzylink`** confirmed |
| 2 | Approve `app_links` package | Decision | ✅ | **`app_links`** approved |
| 3 | Choose GoRouter migration scope | Decision | ✅ | **Option A — Full migration** (replace all Navigator.push with GoRouter) |
| 4 | Confirm iOS bundle identifier | Verification | ✅ | **`com.fuzzzytechnologies.fuzzy_chat`** — same across Android and iOS |
| 5 | Test deep links on physical devices | Testing | ⬜ | Post-implementation |
| 6 | Provide Georgian translations | Content | ✅ | AI can generate placeholder Georgian — mark with `// TODO: verify translation` |
| 7 | Verify app icon / launch screen | Design | ⬜ | Post-implementation |
| 8 | Choose payload expiration duration | Decision | ✅ | **24 hours** for invitations & acceptances, **no expiration** for fuzz messages |
| 9 | Decide on QR code scope (V1 vs V2) | Decision | ✅ | **Defer to V2** — deep links only for V1 |
| 10 | Update store listing / privacy policy | Administrative | ⬜ | Post-ship |

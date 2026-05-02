# 🔗 Fuzzy Chat — Deep Link & OneLink Feature

> **Feature Name:** FuzzyLink  
> **Status:** Planning  
> **Created:** 2026-05-02  
> **Priority:** High — Core UX Simplification  

---

## 📋 Document Index

| # | Document | Purpose |
|---|----------|---------|
| 00 | **This file** | Feature overview, vision, and architecture |
| 01 | [Flow Design](./01_flow_design.md) | Complete user journey diagrams for all 3 link types |
| 02 | [URI Scheme & Payload Design](./02_uri_scheme_design.md) | Technical spec for URI formats, encoding, and security |
| 03 | [Platform Setup Guide](./03_platform_setup.md) | Android, iOS, macOS, web — native configuration |
| 04 | [Implementation Phases](./04_implementation_phases.md) | Phased engineering plan with file-level detail |
| 05 | [Security Analysis](./05_security_analysis.md) | Threat model, mitigations, and security decisions |
| 06 | [UX Enhancements & Ideas](./06_ux_enhancements.md) | Extra ideas to make Fuzzy Chat even simpler and more powerful |
| 07 | [Developer Tasks](./07_developer_tasks.md) | Manual steps, setups, and decisions that require YOUR involvement |

---

## 🎯 The Problem

Today, establishing a secure Fuzzy Chat channel requires **6 manual steps**:

```
Alice                                    Bob
  │                                       │
  ├─ 1. Create chat ──────────────────────│
  ├─ 2. Copy invitation blob ────────────►│
  │    (manually via SMS/email/etc)       │
  │                                       ├─ 3. Paste invitation into Fuzzy Chat
  │                                       ├─ 4. Copy acceptance blob
  │◄──────────── 5. Send acceptance ──────┤
  │    (manually via SMS/email/etc)       │
  ├─ 6. Paste acceptance into Fuzzy Chat  │
  │                                       │
  ╰── Connected! ─────────────────────────╯
```

And for every message exchange:
```
Alice                                    Bob
  ├─ Type message → Copy encrypted fuzz ─►│ Paste fuzz → Read decrypted
  │◄─ Paste fuzz ← Copy encrypted fuzz ──┤ Type message
```

This works, but it's **friction-heavy**. Users must manually copy, switch apps, paste, switch back, copy again, switch, paste again.

---

## ✨ The Vision: FuzzyLink

**FuzzyLink** turns every piece of Fuzzy Chat data into a tappable link. Instead of copy-pasting blobs of encrypted text, users share **links** that, when tapped:

1. **Open Fuzzy Chat automatically**
2. **Process the payload without manual pasting**
3. **Navigate to the correct screen**

### The New Flow

```
Alice                                    Bob
  │                                       │
  ├─ 1. Create chat ──────────────────────│
  ├─ 2. Share invitation LINK ──────────►│  (via any channel)
  │                                       ├─ 3. TAP link → Fuzzy Chat opens
  │                                       │    → auto-accepts → shows acceptance LINK
  │◄──────────── 4. TAP to share ────────┤
  ├─ 5. TAP link → Connection complete!   │
  │                                       │
  ╰── Connected! ─────────────────────────╯
```

**Steps reduced from 6 to 3 taps.** No copy-pasting at all.

For messages:
```
Alice                                    Bob
  ├─ Type message → Share fuzz LINK ────►│ TAP link → auto-decrypts → shows message
  │◄─ TAP link ← Share fuzz LINK ───────┤ Type message → Share fuzz LINK
```

**Zero manual paste. Zero manual decrypt.**

---

## 🔗 Three Link Types

### 1. Invitation Link (`fuzzylink://invite/...`)
- **Contains:** Chat ID + Sender's RSA public key (base64url encoded)
- **When tapped:** Opens Fuzzy Chat → Invitation Acceptance page → pre-filled invitation
- **User action:** Name the chat → Accept → Generates acceptance link automatically

### 2. Acceptance Link (`fuzzylink://accept/...`)
- **Contains:** Chat ID + Acceptor's RSA public key + encrypted symmetric key (base64url encoded)  
- **When tapped:** Opens Fuzzy Chat → Completes handshake → Navigates to connected chat
- **User action:** None! Connection established automatically.

### 3. Encrypted Message Link (`fuzzylink://fuzz/...`)
- **Contains:** Sender's chat ID + encrypted message payload (base64url encoded)
- **When tapped:** Opens Fuzzy Chat → Matches to correct chat → Auto-decrypts → Shows message in chat
- **User action:** None! Message appears as a received message in the chat.

---

## 🏗 Architecture Overview

```
                    ┌─────────────────────────────────┐
                    │         Platform Layer           │
                    │  Android Intent Filters          │
                    │  iOS Universal Links / URL Scheme│
                    │  macOS URL Scheme                │
                    │  Web URL Params                  │
                    └──────────┬──────────────────────┘
                               │
                               ▼
                    ┌─────────────────────────────────┐
                    │      FuzzyLink Service           │
                    │  (lib/src/core/services/)        │
                    │                                  │
                    │  ├─ FuzzyLinkParser              │
                    │  │  (URI → FuzzyLinkPayload)     │
                    │  │                               │
                    │  ├─ FuzzyLinkGenerator            │
                    │  │  (Data → URI string)           │
                    │  │                               │
                    │  └─ FuzzyLinkHandler              │
                    │     (Payload → Navigation action) │
                    └──────────┬──────────────────────┘
                               │
                               ▼
                    ┌─────────────────────────────────┐
                    │     Deep Link Router             │
                    │  (hooks into App widget)         │
                    │                                  │
                    │  Listens for incoming links:     │
                    │  - Cold start (initial link)     │
                    │  - Warm start (while app open)   │
                    │                                  │
                    │  Routes to correct page/cubit    │
                    └─────────────────────────────────┘
```

---

## 🔐 Security Model (Summary)

> Full details in [Security Analysis](./05_security_analysis.md)

| Concern | Mitigation |
|---------|-----------|
| Link interception | Payloads are **already encrypted** — intercepting a link gives attacker encrypted data they can't use without local keys |
| Replay attacks | Chat IDs are UUIDs — replaying an old link won't create duplicate chats (name uniqueness check + chat existence check) |
| Payload tampering | Modified payloads will fail cryptographic verification (RSA signature / AES decryption failure = graceful error) |
| Link phishing | App validates payload structure before processing — malformed links show a clear error, never silently fail |
| Offline principle preserved | **No server is involved.** Links are just formatted URIs containing the same data that was previously copy-pasted. The transport channel (SMS, email, etc.) is still chosen by the user. |

### Key Principle: FuzzyLink Does NOT Break Offline-First

FuzzyLink does **not** introduce any network dependency. It simply changes the **format** of the data being shared — from raw encrypted text to a URI-formatted string. The user still shares this via whatever channel they choose. Fuzzy Chat never phones home.

---

## 🧩 Technology Choices

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| Deep link handling | `app_links` package (or custom platform channels) | Well-maintained, supports Android App Links, iOS Universal Links, and custom URL schemes |
| URI scheme | Custom `fuzzylink://` scheme | No server needed, works offline, no domain verification required |
| Payload encoding | Base64URL | URL-safe encoding for binary crypto data |
| Link generation | `share_plus` (already in pubspec) | Native share sheet — user picks the transport channel |
| Routing | Migrate to `go_router` (already in pubspec but unused) | GoRouter has built-in deep link support — perfect opportunity to wire it up |

---

## 📊 Impact Assessment

| Metric | Before | After |
|--------|--------|-------|
| Steps to connect (new chat) | 6 manual copy-pastes | 3 taps |
| Steps to exchange a message | 2 copy-pastes per message | 1 tap per message |
| Technical complexity | Copy/paste only | Custom URL scheme + platform config + GoRouter |
| Offline preserved? | ✅ | ✅ — no server, no API, no network calls |
| Platforms supported | All (copy-paste works everywhere) | Android, iOS, macOS (deep links) + Web (URL params) + Desktop (fallback to copy-paste) |

---

## ⚡ Quick Start

Read the documents in order:
1. **[Flow Design](./01_flow_design.md)** — understand the complete user journey
2. **[URI Scheme Design](./02_uri_scheme_design.md)** — understand the technical protocol  
3. **[Security Analysis](./05_security_analysis.md)** — understand the threat model
4. **[Platform Setup](./03_platform_setup.md)** — understand what native config is needed
5. **[Implementation Phases](./04_implementation_phases.md)** — understand the build plan
6. **[UX Enhancements](./06_ux_enhancements.md)** — bonus ideas
7. **[Developer Tasks](./07_developer_tasks.md)** — what YOU need to do manually

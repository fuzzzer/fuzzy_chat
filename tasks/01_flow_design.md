# 📐 Flow Design — FuzzyLink User Journeys

> Complete user experience flows for all three deep link types, covering both cold-start and warm-start scenarios.

---

## 1. Invitation Link Flow

### 1A. Sender Journey (Alice creates and shares invitation)

```
Alice's Device
┌─────────────────────────────────────────────────────┐
│                                                     │
│  ChatListPage                                       │
│  ├─ [+ New Chat] button                             │
│  └─── Navigates to ChatCreationPage                 │
│                                                     │
│  ChatCreationPage                                   │
│  ├─ Enter chat name: "Bob Private"                  │
│  ├─ [Create] button                                 │
│  └─── Generates RSA key pair locally                │
│       Navigates to ChatInvitationPage               │
│                                                     │
│  ChatInvitationPage (ENHANCED)                      │
│  ├─ Shows: "Share this invitation with Bob"         │
│  │                                                  │
│  ├─ [📋 Copy Fuzz] — existing behavior (raw text)   │
│  │                                                  │
│  ├─ [🔗 Share as Link] — NEW!                       │
│  │   └── Generates: fuzzylink://invite/<payload>    │
│  │       Opens native share sheet (share_plus)      │
│  │       User picks: SMS, Telegram, Email, AirDrop  │
│  │                                                  │
│  ├─ [📄 Share as Text] — NEW! (share raw fuzz text) │
│  │                                                  │
│  ├─ Waiting for acceptance...                       │
│  │   ├─ [📋 Paste Acceptance] — existing behavior   │
│  │   └─ (auto-detected via deep link — see 2B)     │
│  └─────────────────────────────────────────────────  │
└─────────────────────────────────────────────────────┘
```

### 1B. Receiver Journey (Bob taps invitation link)

#### Scenario A: Cold Start (Fuzzy Chat not running)

```
Bob's Device
┌─────────────────────────────────────────────────────┐
│                                                     │
│  SMS / Telegram / Email / Any App                   │
│  ├─ Message from Alice:                             │
│  │   "Hey Bob, tap this to connect on Fuzzy Chat:   │
│  │    fuzzylink://invite/eyJJIjoiYW..."             │
│  │                                                  │
│  ├─ Bob TAPS the link                               │
│  │                                                  │
│  ▼                                                  │
│  Fuzzy Chat launches (cold start)                   │
│  ├─ Initializer runs (preAppInit)                   │
│  ├─ FuzzyLinkHandler captures the initial link      │
│  ├─ Auth check (if auth is enabled)                 │
│  │                                                  │
│  ▼                                                  │
│  InvitationAcceptancePage (auto-navigated)           │
│  ├─ Invitation is PRE-FILLED (not manual paste!)    │
│  ├─ Shows: "Alice wants to connect"                 │
│  ├─ [Chat Name] text field (Bob enters a name)      │
│  ├─ [✅ Accept & Connect] button                    │
│  │   └── Generates keys, creates acceptance         │
│  │                                                  │
│  ▼                                                  │
│  AcceptanceExportPage (ENHANCED)                    │
│  ├─ Shows: "Send this back to Alice"                │
│  ├─ [🔗 Share as Link] — NEW!                       │
│  │   └── Generates: fuzzylink://accept/<payload>    │
│  │       Opens native share sheet                   │
│  ├─ [📋 Copy Fuzz] — existing behavior              │
│  │                                                  │
│  ├─ [✅ Done] — navigates to ConnectedChatPage      │
│  └─────────────────────────────────────────────────  │
└─────────────────────────────────────────────────────┘
```

#### Scenario B: Warm Start (Fuzzy Chat already open)

```
Bob's Device
┌─────────────────────────────────────────────────────┐
│                                                     │
│  Fuzzy Chat is open (ChatListPage or any page)      │
│  ├─ FuzzyLinkHandler receives link via stream        │
│  ├─ Shows confirmation overlay:                     │
│  │   "Incoming invitation from a contact.            │
│  │    Process it?"                                  │
│  │   [Accept] [Dismiss]                             │
│  │                                                  │
│  ├─ If [Accept]:                                    │
│  │   └── Navigates to InvitationAcceptancePage      │
│  │       (same flow as cold start)                  │
│  └─────────────────────────────────────────────────  │
└─────────────────────────────────────────────────────┘
```

---

## 2. Acceptance Link Flow

### 2A. Receiver Journey (Alice taps acceptance link)

#### Cold Start

```
Alice's Device
┌─────────────────────────────────────────────────────┐
│                                                     │
│  SMS / Telegram / Email / Any App                   │
│  ├─ Message from Bob:                               │
│  │   "Done! Tap to connect:                         │
│  │    fuzzylink://accept/eyJJIjoiYW..."             │
│  │                                                  │
│  ├─ Alice TAPS the link                             │
│  │                                                  │
│  ▼                                                  │
│  Fuzzy Chat launches (cold start)                   │
│  ├─ FuzzyLinkHandler captures initial link          │
│  ├─ Parses acceptance payload                       │
│  ├─ Finds matching chat by chatId in payload        │
│  │                                                  │
│  ├─ IF chat found & status is "pending":            │
│  │   ├─ Completes handshake automatically           │
│  │   │   (decrypts symmetric key, saves keys)       │
│  │   ├─ Updates chat status → "connected"           │
│  │   ├─ Shows success toast: "Connected with Bob!"  │
│  │   └── Navigates to ConnectedChatPage             │
│  │                                                  │
│  ├─ IF chat not found:                              │
│  │   └── Shows error: "No matching invitation found" │
│  │                                                  │
│  ├─ IF chat already connected:                      │
│  │   └── Shows info: "Already connected!"           │
│  │       Navigates to existing ConnectedChatPage    │
│  └─────────────────────────────────────────────────  │
└─────────────────────────────────────────────────────┘
```

#### Warm Start

```
Alice's Device
┌─────────────────────────────────────────────────────┐
│                                                     │
│  Fuzzy Chat is open (ChatInvitationPage!)            │
│  ├─ FuzzyLinkHandler receives acceptance link       │
│  │                                                  │
│  ├─ SMART DETECTION: If user is on                  │
│  │   ChatInvitationPage for the matching chatId:    │
│  │   └── Auto-completes handshake (no overlay!)     │
│  │       Shows success → Navigates to chat          │
│  │                                                  │
│  ├─ If on a different page:                         │
│  │   └── Shows overlay: "Acceptance received!       │
│  │       Complete connection?"                      │
│  │       [Connect] [Later]                          │
│  └─────────────────────────────────────────────────  │
└─────────────────────────────────────────────────────┘
```

---

## 3. Encrypted Message Link Flow

### 3A. Sender Journey (Alice shares encrypted message as link)

```
Alice's Device
┌─────────────────────────────────────────────────────┐
│                                                     │
│  ConnectedChatPage (with Bob)                        │
│  ├─ Alice types: "Meeting at 3pm, don't be late"    │
│  ├─ [Send] — encrypts message, stores locally       │
│  │                                                  │
│  ├─ On the sent message bubble:                     │
│  │   ├─ Long press → context menu:                  │
│  │   │   ├─ [📋 Copy Fuzz] — existing behavior      │
│  │   │   ├─ [🔗 Share as Link] — NEW!               │
│  │   │   │   └── fuzzylink://fuzz/<payload>         │
│  │   │   │       Opens share sheet                  │
│  │   │   ├─ [📄 Share as Text] — share raw fuzz     │
│  │   │   └─ [🗑 Delete]                             │
│  └─────────────────────────────────────────────────  │
└─────────────────────────────────────────────────────┘
```

### 3B. Receiver Journey (Bob taps fuzz message link)

```
Bob's Device
┌─────────────────────────────────────────────────────┐
│                                                     │
│  SMS / Telegram / Any App                           │
│  ├─ Message from Alice:                             │
│  │   "fuzzylink://fuzz/eyJjaWQiOi..."               │
│  │                                                  │
│  ├─ Bob TAPS the link                               │
│  │                                                  │
│  ▼                                                  │
│  Fuzzy Chat launches (or comes to foreground)       │
│  ├─ FuzzyLinkHandler parses fuzz payload            │
│  ├─ Extracts: chatId + encryptedMessage              │
│  │                                                  │
│  ├─ IF matching chat found (by chatId):             │
│  │   ├─ Retrieves symmetric key for that chat       │
│  │   ├─ Decrypts message                            │
│  │   ├─ Saves as received message in chat           │
│  │   ├─ Navigates to ConnectedChatPage              │
│  │   └── Message appears in chat history!           │
│  │                                                  │
│  ├─ IF no matching chat:                            │
│  │   └── Shows error: "No matching chat found.      │
│  │       You need to establish a connection first."  │
│  │                                                  │
│  ├─ IF decryption fails:                            │
│  │   └── Shows error: "Could not decrypt message.   │
│  │       The message may be corrupted."             │
│  └─────────────────────────────────────────────────  │
└─────────────────────────────────────────────────────┘
```

---

## 4. Auth Integration

```
┌─────────────────────────────────────────────────────┐
│  Deep Link Received (any type)                      │
│  │                                                  │
│  ├─ Is app locked (auth enabled)?                   │
│  │   ├─ YES → Store pending link                    │
│  │   │        Show auth page                        │
│  │   │        On success → process stored link      │
│  │   │                                              │
│  │   └─ NO → Process link immediately               │
│  └─────────────────────────────────────────────────  │
└─────────────────────────────────────────────────────┘
```

---

## 5. Fallback: Copy-Paste Still Works

**Every screen that now has "Share as Link" still keeps the original "Copy Fuzz" button.** Deep links are additive — they don't replace the existing manual flow. This ensures:

1. **Desktop users** (Windows, Linux, where custom schemes may not work) still have the full experience
2. **Power users** who prefer raw text can still copy/paste
3. **Backward compatibility** — old invitation blobs still work

---

## 6. Edge Cases & Error States

| Scenario | Behavior |
|----------|----------|
| Link tapped but Fuzzy Chat not installed | OS shows "No app found" — standard behavior |
| Link tapped on platform without deep link support | Nothing happens — user can still copy the payload portion and paste manually |
| Malformed link (corrupted payload) | Error screen: "This link is invalid or corrupted" |
| Link for a chat that was deleted | Error: "This chat no longer exists on your device" |
| Invitation link tapped by the sender themselves | Warning: "You can't accept your own invitation" (chat ID match check) |
| Duplicate acceptance link tapped | Info: "Already connected!" → navigates to chat |
| App in background, link tapped | App comes to foreground, processes link |
| Multiple links queued rapidly | Process first link, queue remainder with dismissible toasts |

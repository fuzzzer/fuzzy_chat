# 🔧 URI Scheme & Payload Design

> Technical specification for how FuzzyLinks are structured, encoded, and validated.

---

## 1. URI Scheme

### Custom Scheme: `fuzzylink://`

We use a **custom URL scheme** rather than HTTP universal links because:
- ✅ No server needed (aligns with offline-first principle)
- ✅ No domain verification required  
- ✅ No Apple/Google association file hosting needed
- ✅ Works on all platforms (Android, iOS, macOS) out of the box
- ✅ Zero infrastructure cost

### URI Format

```
fuzzylink://<type>/<base64url_encoded_payload>
```

Where `<type>` is one of:
- `invite` — invitation payload
- `accept` — acceptance payload
- `fuzz` — encrypted message payload

---

## 2. Payload Encoding

### Why Base64URL (not standard Base64)?

Standard Base64 uses `+`, `/`, and `=` which are problematic in URIs. Base64URL replaces:
- `+` → `-`
- `/` → `_`
- `=` padding → omitted (reconstructed during decode)

This ensures the payload is URL-safe without percent-encoding overhead.

### Encoding Pipeline

```
Raw JSON payload
    │
    ▼
UTF-8 encode → bytes
    │
    ▼
Deflate compress (optional, for large payloads)
    │
    ▼
Base64URL encode → URL-safe string
    │
    ▼
Append to: fuzzylink://<type>/<encoded_string>
```

### Decoding Pipeline

```
fuzzylink://<type>/<encoded_string>
    │
    ▼
Extract type + encoded_string
    │
    ▼
Base64URL decode → bytes
    │
    ▼
Inflate decompress (if compressed)
    │
    ▼
UTF-8 decode → JSON string
    │
    ▼
JSON parse → FuzzyLinkPayload object
```

---

## 3. Payload Structures

### 3A. Invitation Payload

```json
{
  "v": 1,
  "t": "inv",
  "I": "<base64_encoded_chat_id>",
  "P": "<base64_encoded_public_key_json>"
}
```

| Field | Type | Description |
|-------|------|-------------|
| `v` | int | Protocol version (future-proofing) |
| `t` | string | Payload type: `"inv"` |
| `I` | string | Base64-encoded chat ID (matching existing `HandshakeService.chatIdKey`) |
| `P` | string | Base64-encoded RSA public key JSON (matching existing `HandshakeService.publicKeyKey`) |

**Backward compatibility:** The inner `I` and `P` fields use the **exact same format** as the current `HandshakeService.generateInvitation()`. This means:
- An invitation deep link payload IS the same JSON that's currently copied to clipboard
- The only change is wrapping it in the URI scheme

### 3B. Acceptance Payload

```json
{
  "v": 1,
  "t": "acc",
  "I": "<base64_encoded_chat_id>",
  "P": "<base64_encoded_public_key_json>",
  "E": "<base64_encoded_encrypted_symmetric_key>"
}
```

| Field | Type | Description |
|-------|------|-------------|
| `v` | int | Protocol version |
| `t` | string | Payload type: `"acc"` |
| `I` | string | Base64-encoded chat ID |
| `P` | string | Base64-encoded RSA public key JSON |
| `E` | string | Base64-encoded encrypted symmetric key |

**Again:** Same inner format as `HandshakeService.generateAcceptance()`.

### 3C. Encrypted Message Payload

```json
{
  "v": 1,
  "t": "fuz",
  "c": "<chat_id>",
  "m": "<encrypted_message_content>"
}
```

| Field | Type | Description |
|-------|------|-------------|
| `v` | int | Protocol version |
| `t` | string | Payload type: `"fuz"` |
| `c` | string | Chat ID (used to find the right chat and symmetric key) |
| `m` | string | The AES-encrypted message (same format as `MessageData.encryptedMessage`) |

---

## 4. URI Size Considerations

### Maximum URI Lengths by Channel

| Channel | Max Length | Notes |
|---------|-----------|-------|
| Android Intent | ~2MB | Practical limit — no issue |
| iOS URL handling | ~2MB | Practical limit — no issue |
| SMS | ~1600 chars (10 segments) | RSA-2048 public key ≈ 600 chars encoded — fits comfortably |
| WhatsApp/Telegram | ~65,535 chars | No issue |
| Email | No practical limit | No issue |
| Browser URL bar | ~2,048 chars (varies) | Fits for invites/accepts, may be tight for very long messages |

### Estimated Payload Sizes

| Link Type | Estimated Encoded Size | Fits in SMS? |
|-----------|----------------------|-------------|
| Invitation | ~800–1200 chars | ✅ Yes (multiple SMS segments, but works) |
| Acceptance | ~1000–1400 chars | ✅ Yes (multiple segments) |
| Fuzz message (short text) | ~200–500 chars | ✅ Yes |
| Fuzz message (long text) | Variable, can exceed 2000+ chars | ⚠️ Use share sheet, not SMS |

### Compression Strategy

For payloads >500 chars, apply **DEFLATE compression** before base64url encoding:

```dart
import 'dart:io';

Uint8List compress(String json) {
  final bytes = utf8.encode(json);
  return ZLibEncoder(level: ZLibOption.maxLevel).convert(bytes);
}

String decompress(Uint8List compressed) {
  final bytes = ZLibDecoder().convert(compressed);
  return utf8.decode(bytes);
}
```

Add a compression flag to the outer URI:
```
fuzzylink://invite/z/<compressed_base64url>   ← "z" = compressed
fuzzylink://invite/<uncompressed_base64url>   ← no flag = raw
```

---

## 5. Version Field (`v`)

The `v` field enables forward/backward compatibility:

```dart
class FuzzyLinkPayload {
  static const currentVersion = 1;
  
  final int version;
  final FuzzyLinkType type;
  final Map<String, dynamic> data;
  
  bool get isSupported => version <= currentVersion;
  
  // Future: if v == 2 arrives, we can add migration logic
}
```

If a user receives a link with `v > currentVersion`:
- Show message: "Please update Fuzzy Chat to open this link"

---

## 6. FuzzyLink URI Examples

### Invitation Link

```
fuzzylink://invite/eyJ2IjoxLCJ0IjoiaW52IiwiSSI6ImFHVnNiRzh0ZDI5eWJHUT0iLCJQIjoiZXlKdUlqb2lNVEl6TkRVMk56ZzVNQ0lzSW1VaU9pSTJOVFV6TnlKOSJ9
```

Decoded payload:
```json
{
  "v": 1,
  "t": "inv",
  "I": "aGVsbG8td29ybGQ=",
  "P": "eyJuIjoiMTIzNDU2Nzg5MCIsImUiOiI2NTUzNyJ9"
}
```

### Acceptance Link

```
fuzzylink://accept/eyJ2IjoxLCJ0IjoiYWNjIiwiSSI6ImFHVnNiRzh0ZDI5eWJHUT0iLCJQIjoiZXlKdUlqb2lPVGczTmpVME16SXhJaXdpWlNJNklqWTFOVE0zSW4wPSIsIkUiOiJlbmNyeXB0ZWRfa2V5X2hlcmU9In0=
```

### Fuzz Message Link

```
fuzzylink://fuzz/eyJ2IjoxLCJ0IjoiZnV6IiwiYyI6ImFiY2QxMjM0IiwibSI6IlUyRnNkR1ZrWDIxbGMzTmhaMlU9In0=
```

---

## 7. Hybrid Approach: Link + Fallback Text

When sharing via the native share sheet, include both the link AND a human-readable wrapper:

```
🔐 Fuzzy Chat Invitation

Tap the link below to connect:
fuzzylink://invite/eyJ2IjoxLC...

────────────────────
Can't tap? Copy this and paste into Fuzzy Chat:
{"I":"aGVsbG8t...","P":"eyJuIjoi..."}
```

This provides:
1. **Link** — for platforms that support deep links (mobile)
2. **Raw fuzz** — for platforms that don't (desktop, web)
3. **Human context** — so the recipient understands what the message is

### Implementation

```dart
String generateShareableContent({
  required String link,
  required String rawFuzz,
  required FuzzyLinkType type,
}) {
  final typeLabel = switch (type) {
    FuzzyLinkType.invitation => 'Invitation',
    FuzzyLinkType.acceptance => 'Acceptance',
    FuzzyLinkType.fuzz => 'Encrypted Message',
  };
  
  return '''
🔐 Fuzzy Chat $typeLabel

Tap the link to open in Fuzzy Chat:
$link

────────────────────
Can't tap? Copy the text below and paste into Fuzzy Chat:
$rawFuzz
''';
}
```

---

## 8. FuzzyLinkType Enum

```dart
enum FuzzyLinkType {
  invitation('invite', 'inv'),
  acceptance('accept', 'acc'),
  fuzz('fuzz', 'fuz');

  const FuzzyLinkType(this.uriSegment, this.payloadCode);
  
  final String uriSegment;   // used in URI path
  final String payloadCode;  // used in JSON payload
  
  static FuzzyLinkType? fromUriSegment(String segment) {
    return FuzzyLinkType.values.firstWhereOrNull(
      (type) => type.uriSegment == segment,
    );
  }
  
  static FuzzyLinkType? fromPayloadCode(String code) {
    return FuzzyLinkType.values.firstWhereOrNull(
      (type) => type.payloadCode == code,
    );
  }
}
```

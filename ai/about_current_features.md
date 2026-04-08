# Fuzzy Chat: About Current Features

## 1. Local Chat Spaces
- **Offline Generation**: The app creates isolated data environments representing a "chat" with a specific person.
- **Link Handshake System**: Connect securely using copy/paste codes.
  - *Invitation*: The initiator generates an invite code (which contains their public key & chat identifier).
  - *Acceptance*: The receiver inputs the invite code, generates an acceptance code containing their part of the handshake.
  - *Verification*: The initiator pastes the acceptance code back in. The channel is active.

## 2. Text Fuzzing (Encryption/Decryption)
- Inside a connected chat, any typed text is encrypted (Fuzzed) upon pressing send.
- The UI handles the payload string. Fuzzed text always starts with a specific identifier.
- Pasting a fuzzed text into the chat input and pressing send automatically decrypts it and adds the plain text to the local chat view.

## 3. File Fuzzing
- Send files by selecting or dragging them.
- Files are encrypted securely into `.fzz` (or specifically identified) fuzzy files.
- Users can then share these files externally.
- Receiving an encrypted file allows automatic decryption inside the chat interface.

## 4. Local Storage
- All messages, encrypted and unencrypted, along with chat states and cryptographic keys, are stored entirely on the device.
- No remote server connectivity exists or is required, isolating the data.

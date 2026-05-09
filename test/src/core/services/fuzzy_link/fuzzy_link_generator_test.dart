import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fuzzy_chat/lib.dart';

void main() {
  group('FuzzyLinkGenerator', () {
    group('generateInvitationLink', () {
      test('generates valid invitation URI', () {
        final chatId = base64.encode(utf8.encode('test-chat-id'));
        final publicKey = base64.encode(utf8.encode('{"n":"abc","e":"def"}'));
        final invitationContent = jsonEncode({'I': chatId, 'P': publicKey});

        final link =
            FuzzyLinkGenerator.generateInvitationLink(invitationContent);

        expect(link, startsWith('fuzzylink://invite/'));
        final uri = Uri.parse(link);
        expect(uri.scheme, 'fuzzylink');
        expect(uri.host, 'invite');
        expect(uri.pathSegments, hasLength(1));
        expect(uri.pathSegments.first, isNotEmpty);
      });

      test('generated invitation link round-trips through parser', () {
        final chatId = base64.encode(utf8.encode('round-trip-chat'));
        final publicKey = base64.encode(utf8.encode('{"n":"123","e":"456"}'));
        final invitationContent = jsonEncode({'I': chatId, 'P': publicKey});

        final link =
            FuzzyLinkGenerator.generateInvitationLink(invitationContent);
        final parsed = FuzzyLinkParser.parse(Uri.parse(link));

        expect(parsed, isA<InvitationLinkPayload>());
        final invitation = parsed! as InvitationLinkPayload;
        expect(invitation.version, FuzzyLinkPayload.currentVersion);
        expect(invitation.type, FuzzyLinkType.invitation);
        expect(invitation.isExpired, isFalse);

        // Verify the raw content preserves the original fields.
        final rawJson =
            jsonDecode(invitation.rawInvitationContent) as Map<String, dynamic>;
        expect(rawJson['I'], chatId);
        expect(rawJson['P'], publicKey);
      });

      test('invitation link includes expiration', () {
        final chatId = base64.encode(utf8.encode('expiry-test'));
        final publicKey = base64.encode(utf8.encode('{"n":"x","e":"y"}'));
        final invitationContent = jsonEncode({'I': chatId, 'P': publicKey});

        final link =
            FuzzyLinkGenerator.generateInvitationLink(invitationContent);
        final parsed =
            FuzzyLinkParser.parse(Uri.parse(link))! as InvitationLinkPayload;

        expect(parsed.expiresAt, isNotNull);
        expect(parsed.isExpired, isFalse);
      });
    });

    group('generateAcceptanceLink', () {
      test('generates valid acceptance URI', () {
        final chatId = base64.encode(utf8.encode('test-chat-id'));
        final publicKey = base64.encode(utf8.encode('{"n":"abc","e":"def"}'));
        final encryptedKey =
            base64.encode(utf8.encode('encrypted-symmetric-key'));
        final acceptanceContent = jsonEncode({
          'I': chatId,
          'P': publicKey,
          'E': encryptedKey,
        });

        final link =
            FuzzyLinkGenerator.generateAcceptanceLink(acceptanceContent);

        expect(link, startsWith('fuzzylink://accept/'));
        final uri = Uri.parse(link);
        expect(uri.scheme, 'fuzzylink');
        expect(uri.host, 'accept');
      });

      test('generated acceptance link round-trips through parser', () {
        final chatId = base64.encode(utf8.encode('round-trip-acc'));
        final publicKey = base64.encode(utf8.encode('{"n":"789","e":"012"}'));
        final encryptedKey = base64.encode(utf8.encode('sym-key-data'));
        final acceptanceContent = jsonEncode({
          'I': chatId,
          'P': publicKey,
          'E': encryptedKey,
        });

        final link =
            FuzzyLinkGenerator.generateAcceptanceLink(acceptanceContent);
        final parsed = FuzzyLinkParser.parse(Uri.parse(link));

        expect(parsed, isA<AcceptanceLinkPayload>());
        final acceptance = parsed! as AcceptanceLinkPayload;
        expect(acceptance.version, FuzzyLinkPayload.currentVersion);
        expect(acceptance.type, FuzzyLinkType.acceptance);
        expect(acceptance.isExpired, isFalse);

        final rawJson =
            jsonDecode(acceptance.rawAcceptanceContent) as Map<String, dynamic>;
        expect(rawJson['I'], chatId);
        expect(rawJson['P'], publicKey);
        expect(rawJson['E'], encryptedKey);
      });
    });

    group('generateFuzzLink', () {
      test('generates valid fuzz message URI', () {
        final link =
            FuzzyLinkGenerator.generateFuzzLink('chat-id-123', 'encrypted-msg');

        expect(link, startsWith('fuzzylink://fuzz/'));
        final uri = Uri.parse(link);
        expect(uri.scheme, 'fuzzylink');
        expect(uri.host, 'fuzz');
      });

      test('generated fuzz link round-trips through parser', () {
        const chatId = 'fuzz-round-trip-chat';
        const encryptedMessage = 'U2FsdGVkX1+encrypted+content';

        final link =
            FuzzyLinkGenerator.generateFuzzLink(chatId, encryptedMessage);
        final parsed = FuzzyLinkParser.parse(Uri.parse(link));

        expect(parsed, isA<FuzzMessageLinkPayload>());
        final fuzz = parsed! as FuzzMessageLinkPayload;
        expect(fuzz.version, FuzzyLinkPayload.currentVersion);
        expect(fuzz.chatId, chatId);
        expect(fuzz.encryptedMessage, encryptedMessage);
      });

      test('fuzz link has no expiration', () {
        final link = FuzzyLinkGenerator.generateFuzzLink('chat-1', 'msg');
        final uri = Uri.parse(link);

        // Decode and check there's no 'exp' field
        final encodedPayload = uri.pathSegments.first;
        final jsonString =
            utf8.decode(base64Url.decode(base64Url.normalize(encodedPayload)));
        final json = jsonDecode(jsonString) as Map<String, dynamic>;

        expect(json.containsKey('exp'), isFalse);
      });
    });

    group('generateShareableContent', () {
      test('generates hybrid share text with link and raw fuzz', () {
        const link = 'fuzzylink://invite/abc123';
        const rawFuzz = '{"I":"encoded","P":"key"}';

        final content = FuzzyLinkGenerator.generateShareableContent(
          link: link,
          rawFuzz: rawFuzz,
          type: FuzzyLinkType.invitation,
        );

        expect(content, contains('Fuzzy Chat Invitation'));
        expect(content, contains(link));
        expect(content, contains(rawFuzz));
        expect(content, contains('────────────────────'));
      });

      test('labels fuzz message type correctly', () {
        final content = FuzzyLinkGenerator.generateShareableContent(
          link: 'fuzzylink://fuzz/xyz',
          rawFuzz: 'encrypted',
          type: FuzzyLinkType.fuzz,
        );

        expect(content, contains('Encrypted Message'));
      });

      test('labels acceptance type correctly', () {
        final content = FuzzyLinkGenerator.generateShareableContent(
          link: 'fuzzylink://accept/xyz',
          rawFuzz: 'acceptance-data',
          type: FuzzyLinkType.acceptance,
        );

        expect(content, contains('Acceptance'));
      });
    });
  });
}

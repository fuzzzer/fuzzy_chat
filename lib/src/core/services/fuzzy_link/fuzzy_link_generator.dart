import 'dart:convert';

import 'components/components.dart';

class FuzzyLinkGenerator {
  static const _scheme = 'fuzzylink';
  static const _expirationDuration = Duration(hours: 24);

  static String generateInvitationLink(String invitationContent) {
    final innerJson = jsonDecode(invitationContent) as Map<String, dynamic>;
    final payload = jsonEncode({
      'v': FuzzyLinkPayload.currentVersion,
      't': FuzzyLinkType.invitation.payloadCode,
      'I': innerJson['I'],
      'P': innerJson['P'],
      'exp': _generateExpirationTimestamp(),
    });
    final encoded = _encodePayload(payload);
    return '$_scheme://invite/$encoded';
  }

  static String generateAcceptanceLink(String acceptanceContent) {
    final innerJson = jsonDecode(acceptanceContent) as Map<String, dynamic>;
    final payload = jsonEncode({
      'v': FuzzyLinkPayload.currentVersion,
      't': FuzzyLinkType.acceptance.payloadCode,
      'I': innerJson['I'],
      'P': innerJson['P'],
      'E': innerJson['E'],
      'exp': _generateExpirationTimestamp(),
    });
    final encoded = _encodePayload(payload);
    return '$_scheme://accept/$encoded';
  }

  static String generateFuzzLink(String chatId, String encryptedMessage) {
    final payload = jsonEncode({
      'v': FuzzyLinkPayload.currentVersion,
      't': FuzzyLinkType.fuzz.payloadCode,
      'c': chatId,
      'm': encryptedMessage,
    });
    final encoded = _encodePayload(payload);
    return '$_scheme://fuzz/$encoded';
  }

  static String generateShareableContent({
    required String link,
    required String rawFuzz,
    required FuzzyLinkType type,
  }) {
    final typeLabel = switch (type) {
      FuzzyLinkType.invitation => 'Invitation',
      FuzzyLinkType.acceptance => 'Acceptance',
      FuzzyLinkType.fuzz => 'Encrypted Message',
    };

    return '🔐 Fuzzy Chat $typeLabel\n'
        '\n'
        'Tap the link to open in Fuzzy Chat:\n'
        '$link\n'
        '\n'
        '────────────────────\n'
        "Can't tap? Copy the text below and paste into Fuzzy Chat:\n"
        '$rawFuzz';
  }

  static int _generateExpirationTimestamp() {
    return DateTime.now().add(_expirationDuration).millisecondsSinceEpoch ~/ 1000;
  }

  static String _encodePayload(String json) {
    final bytes = utf8.encode(json);
    return base64Url.encode(bytes);
  }
}

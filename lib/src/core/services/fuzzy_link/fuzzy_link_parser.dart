import 'dart:convert';

import 'components/components.dart';

class FuzzyLinkParser {
  static const scheme = 'fuzzylink';

  static FuzzyLinkPayload? parse(Uri uri) {
    try {
      if (uri.scheme != scheme) return null;

      final type = FuzzyLinkType.fromUriSegment(uri.host);
      if (type == null) return null;

      final encodedPayload = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      if (encodedPayload == null || encodedPayload.isEmpty) return null;

      final jsonString = _decodePayload(encodedPayload);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      final version = json['v'] as int?;
      if (version == null) return null;
      if (version > FuzzyLinkPayload.currentVersion) return null;

      final payloadType = json['t'] as String?;
      if (payloadType == null) return null;

      final resolvedType = FuzzyLinkType.fromPayloadCode(payloadType);
      if (resolvedType == null || resolvedType != type) return null;

      return switch (type) {
        FuzzyLinkType.invitation => _parseInvitation(json, version),
        FuzzyLinkType.acceptance => _parseAcceptance(json, version),
        FuzzyLinkType.fuzz => _parseFuzz(json, version),
      };
    } catch (_) {
      return null;
    }
  }

  static FuzzyLinkPayload? _parseInvitation(Map<String, dynamic> json, int version) {
    final chatIdEncoded = json['I'] as String?;
    final publicKeyEncoded = json['P'] as String?;
    if (chatIdEncoded == null || publicKeyEncoded == null) return null;

    final exp = json['exp'] as int?;

    final rawContent = jsonEncode({
      'I': chatIdEncoded,
      'P': publicKeyEncoded,
    });

    return InvitationLinkPayload(
      version: version,
      rawInvitationContent: rawContent,
      expiresAt: exp,
    );
  }

  static FuzzyLinkPayload? _parseAcceptance(Map<String, dynamic> json, int version) {
    final chatIdEncoded = json['I'] as String?;
    final publicKeyEncoded = json['P'] as String?;
    final encryptedKeyEncoded = json['E'] as String?;
    if (chatIdEncoded == null || publicKeyEncoded == null || encryptedKeyEncoded == null) {
      return null;
    }

    final exp = json['exp'] as int?;

    final rawContent = jsonEncode({
      'I': chatIdEncoded,
      'P': publicKeyEncoded,
      'E': encryptedKeyEncoded,
    });

    return AcceptanceLinkPayload(
      version: version,
      rawAcceptanceContent: rawContent,
      expiresAt: exp,
    );
  }

  static FuzzyLinkPayload? _parseFuzz(Map<String, dynamic> json, int version) {
    final chatId = json['c'] as String?;
    final encryptedMessage = json['m'] as String?;
    if (chatId == null || encryptedMessage == null) return null;

    return FuzzMessageLinkPayload(
      version: version,
      chatId: chatId,
      encryptedMessage: encryptedMessage,
    );
  }

  static String? _decodePayload(String encoded) {
    try {
      final bytes = base64Url.decode(base64Url.normalize(encoded));
      return utf8.decode(bytes);
    } catch (_) {
      return null;
    }
  }
}

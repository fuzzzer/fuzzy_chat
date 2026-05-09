import 'fuzzy_link_type.dart';

sealed class FuzzyLinkPayload {
  const FuzzyLinkPayload({
    required this.version,
    required this.type,
  });

  final int version;
  final FuzzyLinkType type;

  static const currentVersion = 1;

  bool get isSupported => version <= currentVersion;
}

class InvitationLinkPayload extends FuzzyLinkPayload {
  const InvitationLinkPayload({
    required super.version,
    required this.rawInvitationContent,
    required this.expiresAt,
  }) : super(type: FuzzyLinkType.invitation);

  final String rawInvitationContent;
  final int? expiresAt;

  bool get isExpired =>
      expiresAt != null &&
      DateTime.now().millisecondsSinceEpoch ~/ 1000 > expiresAt!;
}

class AcceptanceLinkPayload extends FuzzyLinkPayload {
  const AcceptanceLinkPayload({
    required super.version,
    required this.rawAcceptanceContent,
    required this.expiresAt,
  }) : super(type: FuzzyLinkType.acceptance);

  final String rawAcceptanceContent;
  final int? expiresAt;

  bool get isExpired =>
      expiresAt != null &&
      DateTime.now().millisecondsSinceEpoch ~/ 1000 > expiresAt!;
}

class FuzzMessageLinkPayload extends FuzzyLinkPayload {
  const FuzzMessageLinkPayload({
    required super.version,
    required this.chatId,
    required this.encryptedMessage,
  }) : super(type: FuzzyLinkType.fuzz);

  final String chatId;
  final String encryptedMessage;
}

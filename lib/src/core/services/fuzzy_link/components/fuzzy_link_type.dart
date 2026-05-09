enum FuzzyLinkType {
  invitation('invite', 'inv'),
  acceptance('accept', 'acc'),
  fuzz('fuzz', 'fuz');

  const FuzzyLinkType(this.uriSegment, this.payloadCode);

  final String uriSegment;
  final String payloadCode;

  static FuzzyLinkType? fromUriSegment(String segment) {
    for (final type in FuzzyLinkType.values) {
      if (type.uriSegment == segment) return type;
    }
    return null;
  }

  static FuzzyLinkType? fromPayloadCode(String code) {
    for (final type in FuzzyLinkType.values) {
      if (type.payloadCode == code) return type;
    }
    return null;
  }
}

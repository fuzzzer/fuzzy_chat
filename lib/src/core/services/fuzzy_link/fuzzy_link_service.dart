import 'package:app_links/app_links.dart';

class FuzzyLinkService {
  FuzzyLinkService({AppLinks? appLinks}) : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;

  Future<Uri?> getInitialLink() async {
    try {
      return await _appLinks.getInitialLink();
    } catch (_) {
      return null;
    }
  }

  Stream<Uri> get onLinkReceived => _appLinks.uriLinkStream;
}

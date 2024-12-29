import 'package:fuzzy_chat/lib.dart';

FuzzyChatLocalizations get currentContextLocalization {
  if (navigatorKey.currentContext == null) {
    return FuzzyChatLocalizationsEn();
  }

  return FuzzyChatLocalizations.of(navigatorKey.currentContext!)!;
}

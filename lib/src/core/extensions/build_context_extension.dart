import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

extension BuildContextExtension on BuildContext {
  FuzzyChatLocalizations get fuzzyChatLocalizations => FuzzyChatLocalizations.of(this)!;
  UiColors get uiColors => Theme.of(this).extension<UiColors>()!;
  UiTextStyles get uiTextStyles => Theme.of(this).extension<UiTextStyles>()!;
}

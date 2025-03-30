import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

extension ContextLocalizationExtension on BuildContext {
  FuzzyChatLocalizations get fuzzyChatLocalizations => FuzzyChatLocalizations.of(this)!;
}

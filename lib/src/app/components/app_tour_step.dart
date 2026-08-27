import 'package:flutter/widgets.dart';

class AppTourStep {
  const AppTourStep({
    required this.targetKey,
    required this.title,
    required this.description,
  });

  final GlobalKey targetKey;
  final String title;
  final String description;
}

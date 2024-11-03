import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/core/dependency_injection.dart';

class Initializer {
  static Future<void> preAppInit() async {
    WidgetsFlutterBinding.ensureInitialized();

    await DependencyInjection.inject();
  }
}

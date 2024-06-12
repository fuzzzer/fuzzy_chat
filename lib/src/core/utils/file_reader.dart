import 'dart:io';

import 'package:flutter/foundation.dart';

Future<String> readFileContent(String fileName) async {
  try {
    final file = File(fileName);
    return await file.readAsString();
  } catch (e) {
    debugPrint('Error reading $fileName: $e');
    return 'Error reading $fileName';
  }
}

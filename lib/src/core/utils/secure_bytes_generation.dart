import 'dart:math';
import 'dart:typed_data';

Uint8List generateRandomSecureBytes(int length) {
  final random = Random.secure();
  return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
}

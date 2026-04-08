import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:fuzzy_chat/lib.dart';

void main() {
  group('AESService', () {
    test('successfully encrypts and decrypts text', () async {
      final symmetricKey = Uint8List.fromList(List.filled(32, 1));
      const text = 'Test Encryption Text';

      final encrypted = await AESService.encryptText(text, symmetricKey);
      
      expect(encrypted, isNotEmpty);
      expect(encrypted, isNot(equals(text)));

      final decrypted = await AESService.decryptText(encrypted, symmetricKey);
      
      expect(decrypted, equals(text));
    });

    test('throws Exception for invalid key length during text encryption', () async {
      final invalidKey = Uint8List.fromList(List.filled(16, 1)); // Invalid length (not 32)
      const text = 'Test Encryption Text';

      expect(
        () => AESService.encryptText(text, invalidKey),
        throwsA(isA<Exception>()),
      );
    });
  });
}

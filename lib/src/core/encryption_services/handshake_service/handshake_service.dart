import 'dart:convert';
import 'dart:typed_data';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:pointycastle/asymmetric/api.dart';

export 'components/components.dart';

class HandshakeService {
  static const chatIdKey = 'I';
  static const publicKeyKey = 'P';
  static const encryptedSymmetricKeyKey = 'E';

  static Future<ToBeSentInvitation> generateInvitation(String chatId, RSAPublicKey publicKey) async {
    final publicKeyMap = RSAService.transformRSAPublicKeyToMap(publicKey);

    final encodedData = {
      chatIdKey: base64.encode(utf8.encode(chatId)),
      publicKeyKey: base64.encode(utf8.encode(jsonEncode(publicKeyMap))),
    };

    final invitationJson = jsonEncode(encodedData);

    return ToBeSentInvitation(chatId: chatId, invitationContent: invitationJson);
  }

  static Future<ReceivedInvitation> parseInvitation(String content) async {
    final decodedData = jsonDecode(content) as Map<String, dynamic>;

    final chatId = utf8.decode(base64.decode(decodedData[chatIdKey] as String));
    final publicKeyJson = utf8.decode(base64.decode(decodedData[publicKeyKey] as String));
    final publicKeyMap = (jsonDecode(publicKeyJson) as Map<String, dynamic>).cast<String, String>();

    final publicKey = RSAService.transformMapToRSAPublicKey(publicKeyMap);
    return ReceivedInvitation(chatId: chatId, publicKey: publicKey);
  }

  static Future<ToBeSentAcceptance> generateAcceptance({
    required String chatId,
    required RSAPublicKey otherPartyPublicKey,
    required Uint8List encryptedSymmetricKey,
  }) async {
    final otherPartyPublicKeyMap = RSAService.transformRSAPublicKeyToMap(otherPartyPublicKey);

    final encodedData = {
      chatIdKey: base64.encode(utf8.encode(chatId)),
      publicKeyKey: base64.encode(utf8.encode(jsonEncode(otherPartyPublicKeyMap))),
      encryptedSymmetricKeyKey: base64.encode(encryptedSymmetricKey),
    };

    final acceptanceJson = jsonEncode(encodedData);

    return ToBeSentAcceptance(
      chatId: chatId,
      acceptanceContent: acceptanceJson,
    );
  }

  static Future<ReceivedAcceptance> parseAcceptance(String content) async {
    final decodedData = jsonDecode(content) as Map<String, dynamic>;

    final chatId = utf8.decode(base64.decode(decodedData[chatIdKey] as String));
    final publicKeyJson = utf8.decode(base64.decode(decodedData[publicKeyKey] as String));
    final publicKeyMap = (jsonDecode(publicKeyJson) as Map<String, dynamic>).cast<String, String>();
    final encryptedSymmetricKey = base64.decode(decodedData[encryptedSymmetricKeyKey] as String);

    final publicKey = RSAService.transformMapToRSAPublicKey(publicKeyMap);

    return ReceivedAcceptance(
      chatId: chatId,
      publicKey: publicKey,
      encryptedSymmetricKey: encryptedSymmetricKey,
    );
  }
}

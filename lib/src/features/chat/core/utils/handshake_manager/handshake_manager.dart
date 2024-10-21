import 'dart:convert';
import 'dart:typed_data';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'components/components.dart';

export 'components/components.dart';

class HandshakeManager {
  final chatIdKey = 'I';
  final publicKeyKey = 'P';
  final encryptedSymmetricKeyKey = 'E';

  Future<ToBeSentInvitation> generateInvitation(String chatId, RSAPublicKey publicKey) async {
    final publicKeyMap = RSAManager.transformRSAPublicKeyToMap(publicKey);

    final encodedData = {
      chatIdKey: base64.encode(utf8.encode(chatId)),
      publicKeyKey: base64.encode(utf8.encode(jsonEncode(publicKeyMap))),
    };

    final invitationJson = jsonEncode(encodedData);

    return ToBeSentInvitation(chatId: chatId, invitationContent: invitationJson);
  }

  Future<ReceivedInvitation> parseInvitation(String content) async {
    final decodedData = jsonDecode(content) as Map<String, dynamic>;

    final chatId = utf8.decode(base64.decode(decodedData[chatIdKey] as String));
    final publicKeyJson = utf8.decode(base64.decode(decodedData[publicKeyKey] as String));
    final publicKeyMap = (jsonDecode(publicKeyJson) as Map<String, dynamic>).cast<String, String>();

    final publicKey = RSAManager.transformMapToRSAPublicKey(publicKeyMap);
    return ReceivedInvitation(chatId: chatId, publicKey: publicKey);
  }

  Future<ToBeSentAcceptance> generateAcceptance({
    required String chatId,
    required RSAPublicKey otherPartyPublicKey,
    required Uint8List encryptedSymmetricKey,
  }) async {
    final otherPartyPublicKeyMap = RSAManager.transformRSAPublicKeyToMap(otherPartyPublicKey);

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

  Future<ReceivedAcceptance> parseAcceptance(String content) async {
    final decodedData = jsonDecode(content) as Map<String, dynamic>;

    final chatId = utf8.decode(base64.decode(decodedData[chatIdKey] as String));
    final publicKeyJson = utf8.decode(base64.decode(decodedData[publicKeyKey] as String));
    final publicKeyMap = (jsonDecode(publicKeyJson) as Map<String, dynamic>).cast<String, String>();
    final encryptedSymmetricKey = base64.decode(decodedData[encryptedSymmetricKeyKey] as String);

    final publicKey = RSAManager.transformMapToRSAPublicKey(publicKeyMap);

    return ReceivedAcceptance(
      chatId: chatId,
      publicKey: publicKey,
      encryptedSymmetricKey: encryptedSymmetricKey,
    );
  }
}

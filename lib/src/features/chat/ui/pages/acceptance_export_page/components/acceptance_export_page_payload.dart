import 'package:fuzzy_chat/src/features/chat/chat.dart';

class AcceptanceExportPagePayload {
  final ChatGeneralData chatGeneralData;
  final bool hasBackButton;

  AcceptanceExportPagePayload({
    required this.chatGeneralData,
    required this.hasBackButton,
  });
}

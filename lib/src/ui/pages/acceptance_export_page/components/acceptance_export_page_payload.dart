import 'package:fuzzy_chat/lib.dart';

class AcceptanceExportPagePayload {
  final ChatGeneralData chatGeneralData;
  final bool hasBackButton;

  AcceptanceExportPagePayload({
    required this.chatGeneralData,
    required this.hasBackButton,
  });
}

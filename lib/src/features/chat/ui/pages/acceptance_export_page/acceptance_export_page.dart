import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

export 'components/components.dart';
export 'widgets/widgets.dart';

class AcceptanceExportPage extends StatelessWidget {
  final AcceptanceExportPagePayload payload;

  const AcceptanceExportPage({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AcceptanceReaderCubit>(
      create: (context) => AcceptanceReaderCubit(
        handshakeManager: sl.get<HandshakeManager>(),
        keyStorageRepository: sl.get<KeyStorageRepository>(),
      )..generateAcceptance(chatId: payload.chatGeneralData.chatId),
      child: ProvidedAcceptanceExportPage(payload: payload),
    );
  }
}

class ProvidedAcceptanceExportPage extends StatelessWidget {
  final AcceptanceExportPagePayload payload;

  const ProvidedAcceptanceExportPage({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final localizations = FuzzyChatLocalizations.of(context)!;

    return BlocBuilder<AcceptanceReaderCubit, AcceptanceReaderState>(
      builder: (context, state) {
        return StatusBuilder.buildByStatus(
          status: state.status,
          onInitial: () => const FuzzyLoadingPagebuilder(),
          onLoading: () => const FuzzyLoadingPagebuilder(),
          onSuccess: () => AcceptanceContent(
            acceptanceContent: state.acceptance!.acceptanceContent,
            hasBackButton: payload.hasBackButton,
            chatGeneralData: payload.chatGeneralData,
          ),
          onFailure: () => FuzzyErrorPageBuilder(
            message: state.failure?.message ?? localizations.failedToReadAcceptance,
          ),
        );
      },
    );
  }
}

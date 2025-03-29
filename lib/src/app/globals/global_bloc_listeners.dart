import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

class GlobalBlocListeners extends StatelessWidget {
  const GlobalBlocListeners({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FileProcessingCubit<FileEncryptionOption>, FileProcessingState>(
          listenWhen: (previous, current) => previous.processedFiles.length != current.processedFiles.length,
          listener: (context, state) {
            if (state.processedFiles.isNotEmpty == true) {
              final readProcessedFiles = state.processedFiles;

              context.read<ChatFileInjectorCubit>().injectProcessedFile(
                    processedFiles: state.processedFiles,
                    filesAreEncrypted: true,
                  );

              context.read<FileProcessingCubit<FileEncryptionOption>>().markProcessedFilesAsReadAndClear(
                    readProcessedFiles: readProcessedFiles,
                  );
            }
          },
        ),
        BlocListener<FileProcessingCubit<FileDecryptionOption>, FileProcessingState>(
          listenWhen: (previous, current) => previous.processedFiles.length != current.processedFiles.length,
          listener: (context, state) {
            if (state.processedFiles.isNotEmpty == true) {
              final readProcessedFiles = state.processedFiles;

              context.read<ChatFileInjectorCubit>().injectProcessedFile(
                    processedFiles: state.processedFiles,
                    filesAreEncrypted: false,
                  );

              context.read<FileProcessingCubit<FileDecryptionOption>>().markProcessedFilesAsReadAndClear(
                    readProcessedFiles: readProcessedFiles,
                  );
            }
          },
        ),
        BlocListener<ChatFileInjectorCubit, ChatFileInjectorState>(
          listenWhen: (previous, current) =>
              previous.failedToAddProcessedFiles != null &&
              previous.failedToAddProcessedFiles?.length != current.failedToAddProcessedFiles?.length,
          listener: (_, state) {
            final localizations = FuzzyChatLocalizations.of(
              navigatorKey.currentContext!,
            )!;

            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  ' ${localizations.failedToProcessFiles}: ${state.failedToAddProcessedFiles?.map(
                    (file) {
                      return file.inputFilePath.split('/').last;
                    },
                  ).toList()}',
                ),
              ),
            );
          },
        ),
      ],
      child: child,
    );
  }
}

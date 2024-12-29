import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

class FileDecryptionTestPage extends StatelessWidget {
  const FileDecryptionTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileProcessingCubit<FileDecryptionOption>, FileProcessingState>(
      builder: (context, state) {
        final cubit = context.read<FileProcessingCubit<FileDecryptionOption>>();

        return Scaffold(
          appBar: AppBar(title: const Text('Decryption Example')),
          body: Column(
            children: [
              FileSelector(
                buttonText: 'Select File(s) to Decrypt',
                allowMultiple: true,
                onSelected: (paths) {
                  cubit.addFilesToProcess(
                    chatId: 'someChatId',
                    filePaths: paths,
                  );
                },
              ),
              if (state.currentProcessingFile != null) ...[
                Text('Decrypting: ${state.currentProcessingFile}'),
                LinearProgressIndicator(value: state.progress),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.pause),
                      onPressed: cubit.pauseFile,
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: cubit.resumeFile,
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: cubit.cancelFile,
                    ),
                  ],
                ),
              ],
              const Divider(),
              Expanded(
                child: ListView(
                  children: [
                    Text('Queue: ${state.toBeProcessedFiles.length} file(s) are waiting or are in-progress.'),
                    ...state.toBeProcessedFiles.map(
                      (f) => ListTile(
                        title: Text(f.inputFilePath),
                        subtitle: Text('Status: ${f.status}, progress: ${f.progress.toStringAsFixed(2)}'),
                      ),
                    ),
                    const Divider(),
                    Text('Processed: ${state.processedFiles.length} file(s).'),
                    ...state.processedFiles.map(
                      (f) => ListTile(
                        title: Text(f.inputFilePath),
                        subtitle: Text(
                          f.status == FileProcessingStatus.completed
                              ? 'Decrypted -> ${f.outputFilePath}'
                              : 'Status: ${f.status}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

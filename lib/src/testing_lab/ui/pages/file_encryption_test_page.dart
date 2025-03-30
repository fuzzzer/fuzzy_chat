import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

class FileEncryptionTestPage extends StatelessWidget {
  const FileEncryptionTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileProcessingCubit<FileEncryptionOption>, FileProcessingState>(
      builder: (context, state) {
        final fileEncryptionCubit = context.read<FileProcessingCubit<FileEncryptionOption>>();

        return Scaffold(
          appBar: AppBar(title: const Text('Encryption Example')),
          body: Column(
            children: [
              FileSelectorWidget(
                allowMultiple: true,
                selectedFilePaths: const [],
                onSelected: (paths) {
                  fileEncryptionCubit.addFilesToProcess(
                    chatId: 'ed446aea-8c03-4668-b256-bd37c52d340f',
                    chatName: 'test',
                    filePaths: paths,
                  );
                },
              ),
              if (state.currentProcessingFile != null) ...[
                Text('Encrypting: ${state.currentProcessingFile}'),
                LinearProgressIndicator(value: state.progress),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.pause),
                      onPressed: fileEncryptionCubit.pauseFile,
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: fileEncryptionCubit.resumeFile,
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: fileEncryptionCubit.cancelFile,
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
                    Text(
                      state.progress.toString(),
                      style: const TextStyle(
                        fontSize: 100,
                      ),
                    ),
                    const Divider(),
                    Text('Processed: ${state.processedFiles.length} file(s) are done or are canceled.'),
                    ...state.processedFiles.map(
                      (f) => ListTile(
                        title: Text(f.inputFilePath),
                        subtitle: Text(
                          f.status == FileProcessingStatus.completed
                              ? 'Encrypted -> ${f.outputFilePath}'
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

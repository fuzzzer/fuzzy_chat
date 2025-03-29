import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

class GlobalBlocProviders extends StatelessWidget {
  const GlobalBlocProviders({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalizationCubit>(
          create: (_) => LocalizationCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<ChatGeneralDataListCubit>(
          create: (context) => ChatGeneralDataListCubit(
            chatRepository: sl.get<ChatGeneralDataListRepository>(),
            keyStorageRepository: sl.get<KeyStorageRepository>(),
          )..fetchChats(),
        ),
        BlocProvider<FileProcessingCubit<FileEncryptionOption>>(
          create: (_) => FileProcessingCubit<FileEncryptionOption>(
            processingOption: const FileEncryptionOption(),
            keyStorageRepository: sl.get<KeyStorageRepository>(),
          ),
        ),
        BlocProvider<FileProcessingCubit<FileDecryptionOption>>(
          create: (_) => FileProcessingCubit<FileDecryptionOption>(
            processingOption: const FileDecryptionOption(),
            keyStorageRepository: sl.get<KeyStorageRepository>(),
          ),
        ),
        BlocProvider<ChatFileInjectorCubit>(
          create: (_) => ChatFileInjectorCubit(
            messageDataRepository: sl.get<MessageDataRepository>(),
          ),
        ),
      ],
      child: child,
    );
  }
}

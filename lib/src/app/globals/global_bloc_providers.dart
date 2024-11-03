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
        BlocProvider(
          create: (_) => LocalizationCubit(),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
      ],
      child: child,
    );
  }
}

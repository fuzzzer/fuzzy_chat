import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

export 'widgets/widgets.dart';

class FuzzyUserAuthPage extends StatelessWidget {
  const FuzzyUserAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FuzzyUserAuthPreferencesCubit>(
      create: (context) => FuzzyUserAuthPreferencesCubit(
        // TODO: Ensure repository is available via your service locator (like sl.get())
        userAuthPreferencesRepository: sl.get<UserAuthPreferencesRepository>(),
      )..getUserAuthPreferences(),
      child: const _ProvidedFuzzyUserAuthPage(),
    );
  }
}

class _ProvidedFuzzyUserAuthPage extends StatelessWidget {
  const _ProvidedFuzzyUserAuthPage();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with your actual UI components like FuzzyScaffold
    return Scaffold(
      appBar: AppBar(
        title: Text(currentContextLocalization.fuzzyUserAuth),
      ),
      body: BlocBuilder<FuzzyUserAuthPreferencesCubit, FuzzyUserAuthPreferencesState>(
        builder: (context, state) {
          return StatusBuilder.buildByStatus(
            status: state.checkCurrentAuthPreferencesStatus,
            onInitial: DefaultLoadingWidget.new,
            onLoading: DefaultLoadingWidget.new,
            onSuccess: () {
              if (state.currentAuthPreferences == null) {
                return const FuzzyUserAuthEmptyContent();
              }
              return FuzzyUserAuthLoadedContent(
                item: state.currentAuthPreferences!,
              );
            },
            onFailure: () => Center(
              child: Text(
                currentContextLocalization.authError(state.checkCurrentAuthPreferencesFailure?.message ?? currentContextLocalization.unknownError),
              ),
            ),
          );
        },
      ),
    );
  }
}

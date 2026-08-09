import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:fuzzzy_ui_kit/fuzzzy_ui_kit.dart';

export 'app_router.dart';
export 'components/components.dart';
export 'globals/globals.dart';
export 'initializer.dart';
export 'ui/ui.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  static Future<Widget> runner() async {
    await Initializer.preAppInit();

    return const App();
  }

  @override
  Widget build(BuildContext context) {
    final oldTheme = UiKitTheme.dark();
    final fuzzzyTheme = FuzzzyTheme.build(inkPack, FuzzzySkin.night);
    final theme = oldTheme.copyWith(
      extensions: [
        ...oldTheme.extensions.values,
        ...fuzzzyTheme.extensions.values,
      ],
    );

    return GlobalBlocProviders(
      child: GlobalBlocListeners(
        child: FuzzyLinkListener(
          child: MaterialApp.router(
            scaffoldMessengerKey: scaffoldMessengerKey,
            theme: theme,
            localizationsDelegates:
                FuzzyChatLocalizations.localizationsDelegates,
            supportedLocales: FuzzyChatLocalizations.supportedLocales,
            routerConfig: AppRouter.router(
              navigatorKey: navigatorKey,
              scaffoldMessengerKey: scaffoldMessengerKey,
            ),
          ),
        ),
      ),
    );
  }
}

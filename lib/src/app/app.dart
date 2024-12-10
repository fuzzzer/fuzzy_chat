import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

export 'components/components.dart';
export 'globals/globals.dart';
export 'initializer.dart';
export 'run_app.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({super.key});

  static Future<Widget> runner() async {
    await Initializer.preAppInit();

    return const App();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalBlocProviders(
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        theme: UiKitTheme.dark(),
        localizationsDelegates: FuzzyChatLocalizations.localizationsDelegates,
        supportedLocales: FuzzyChatLocalizations.supportedLocales,
        home: const ChatListPage(),
      ),
    );
  }
}

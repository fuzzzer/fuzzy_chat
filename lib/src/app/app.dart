import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

export 'components/components.dart';
export 'globals/globals.dart';
export 'initializer.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  static Future<Widget> runner() async {
    await Initializer.preAppInit();

    return const App();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalBlocProviders(
      child: GlobalBlocListeners(
        child: MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          navigatorKey: navigatorKey,
          theme: UiKitTheme.dark(),
          localizationsDelegates: FuzzyChatLocalizations.localizationsDelegates,
          supportedLocales: FuzzyChatLocalizations.supportedLocales,
          home: const ChatListPage(),
        ),
      ),
    );
  }
}

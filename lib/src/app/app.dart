import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/testing_lab/ui/ui.dart';

export 'components/components.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(26, 181, 168, 168),
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: FuzzyChatLocalizations.localizationsDelegates,
      supportedLocales: FuzzyChatLocalizations.supportedLocales,
      home: const InitialPage(),
    );
  }
}

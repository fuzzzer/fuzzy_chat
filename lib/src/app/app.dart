import 'package:flutter/material.dart';
import 'package:secure_chat/src/core/core.dart';
import 'package:secure_chat/src/ui/ui.dart';

export 'components/components.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: SecureChatLocalizations.localizationsDelegates,
      supportedLocales: SecureChatLocalizations.supportedLocales,
      home: const InitialPage(),
    );
  }
}

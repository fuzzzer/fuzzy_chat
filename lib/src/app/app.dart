import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/app/initializer.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/ui/pages/chat_list_page/chat_list_page.dart';

import '../ui_kit/ui_kit.dart';

export 'components/components.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({super.key});

  static Future<Widget> runner() async {
    await Initializer.preAppInit();

    return const App();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: UiKitTheme.dark(),
      localizationsDelegates: FuzzyChatLocalizations.localizationsDelegates,
      supportedLocales: FuzzyChatLocalizations.supportedLocales,
      home: const ChatListPage(),
    );
  }
}

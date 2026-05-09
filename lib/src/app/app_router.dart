import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static const home = '/';
  static const chatCreate = '/chat/create';
  static const chatInvitation = '/chat/invitation';
  static const chatAccept = '/chat/accept';
  static const chatAcceptanceExport = '/chat/acceptance-export';
  static const chatConnected = '/chat/connected';
  static const settings = '/settings';
  static const auth = '/auth';
  static const basics = '/basics';

  /// Cached router instance for access from [FuzzyLinkHandler].
  static GoRouter? _routerInstance;

  /// Returns the cached [GoRouter] instance. Null before [router] is called.
  static GoRouter? get routerInstance => _routerInstance;

  static GoRouter router({
    required GlobalKey<NavigatorState> navigatorKey,
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  }) {
    _routerInstance ??= GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: home,
      routes: [
        GoRoute(
          path: home,
          builder: (_, __) => sl.get<PreferencesService>().hasSeenOnboarding
              ? const ChatListPage()
              : const OnboardingPage(),
        ),
        GoRoute(
          path: chatCreate,
          builder: (_, __) => const ChatCreationPage(),
        ),
        GoRoute(
          path: chatInvitation,
          builder: (_, state) {
            final payload = state.extra! as ChatInvitationPagePayload;
            return ChatInvitationPage(payload: payload);
          },
        ),
        GoRoute(
          path: chatAccept,
          builder: (_, state) {
            final prefill = state.extra as String?;
            return InvitationAcceptancePage(
              prefillInvitationContent: prefill,
            );
          },
        ),
        GoRoute(
          path: chatAcceptanceExport,
          builder: (_, state) {
            final payload = state.extra! as AcceptanceExportPagePayload;
            return AcceptanceExportPage(payload: payload);
          },
        ),
        GoRoute(
          path: chatConnected,
          builder: (_, state) {
            final payload = state.extra! as ConnectedChatPagePayload;
            return ConnectedChatPage(payload: payload);
          },
        ),
        GoRoute(
          path: settings,
          builder: (_, __) => const SettingsPage(),
        ),
        GoRoute(
          path: auth,
          builder: (_, __) => const FuzzyUserAuthPage(),
        ),
        GoRoute(
          path: basics,
          builder: (_, __) => const BasicEncryptionPage(),
        ),
      ],
    );
    return _routerInstance!;
  }
}

import 'dart:async';

import 'package:fuzzy_chat/lib.dart';
import 'package:fuzzzy_ui_kit/fuzzzy_ui_kit.dart';
import 'package:go_router/go_router.dart';

class FuzzyLinkHandler {
  FuzzyLinkHandler({
    required FuzzyLinkService linkService,
    required ChatGeneralDataListRepository chatRepository,
    required FuzzyAuthStore authStore,
  })  : _linkService = linkService,
        _chatRepository = chatRepository,
        _authStore = authStore;

  final FuzzyLinkService _linkService;
  final ChatGeneralDataListRepository _chatRepository;
  final FuzzyAuthStore _authStore;

  StreamSubscription<Uri>? _subscription;
  FuzzyLinkPayload? _pendingPayload;
  bool _isInitialized = false;

  bool get hasPendingPayload => _pendingPayload != null;

  FuzzyChatLocalizations get _l10n =>
      FuzzyChatLocalizations.of(navigatorKey.currentContext!)!;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    final initialUri = await _linkService.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri);
    }

    _subscription = _linkService.onLinkReceived.listen(_handleUri);
  }

  void processPendingPayload() {
    if (_pendingPayload != null) {
      _processPayload(_pendingPayload!);
      _pendingPayload = null;
    }
  }

  void _handleUri(Uri uri) {
    final payload = FuzzyLinkParser.parse(uri);
    if (payload == null) {
      FuzzzyToast.show(navigatorKey.currentContext!, message: _l10n.invalidLink);
      return;
    }

    if (!payload.isSupported) {
      FuzzzyToast.show(navigatorKey.currentContext!,
          message: _l10n.updateRequired,);
      return;
    }

    if (payload is InvitationLinkPayload && payload.isExpired) {
      FuzzzyToast.show(navigatorKey.currentContext!,
          message: _l10n.invitationLinkExpired,);
      return;
    }
    if (payload is AcceptanceLinkPayload && payload.isExpired) {
      FuzzzyToast.show(navigatorKey.currentContext!,
          message: _l10n.acceptanceLinkExpired,);
      return;
    }

    _routePayload(payload);
  }

  Future<void> _routePayload(FuzzyLinkPayload payload) async {
    if (await _isAppLocked()) {
      _pendingPayload = payload;
      return;
    }

    _processPayload(payload);
  }

  void _processPayload(FuzzyLinkPayload payload) {
    final router = AppRouter.routerInstance;
    if (router == null) return;

    switch (payload) {
      case InvitationLinkPayload():
        _handleInvitation(router, payload);
      case AcceptanceLinkPayload():
        _handleAcceptance(router, payload);
      case FuzzMessageLinkPayload():
        _handleFuzzMessage(router, payload);
    }
  }

  Future<void> _handleInvitation(
      GoRouter router, InvitationLinkPayload payload,) async {
    try {
      final receivedInvitation =
          await HandshakeService.parseInvitation(payload.rawInvitationContent);
      final existingChat =
          await _chatRepository.getChatById(receivedInvitation.chatId);

      if (existingChat != null) {
        FuzzzyToast.show(navigatorKey.currentContext!,
            message: _l10n.cantAcceptOwnInvitation,);
        return;
      }
    } catch (_) {
      // Let the acceptance page handle parsing errors downstream.
    }

    _navigateCleanly(
      router,
      AppRouter.chatAccept,
      extra: payload.rawInvitationContent,
    );
  }

  Future<void> _handleAcceptance(
      GoRouter router, AcceptanceLinkPayload payload,) async {
    try {
      final acceptance =
          await HandshakeService.parseAcceptance(payload.rawAcceptanceContent);
      final chatId = acceptance.chatId;
      final chat = await _chatRepository.getChatById(chatId);

      if (chat == null) {
        FuzzzyToast.show(navigatorKey.currentContext!,
            message: _l10n.chatNotFoundForAcceptance,);
        return;
      }

      if (chat.setupStatus == ChatSetupStatus.connected) {
        FuzzzyToast.show(navigatorKey.currentContext!,
            message: _l10n.alreadyConnected,);
        return;
      }

      _navigateCleanly(
        router,
        AppRouter.chatInvitation,
        extra: ChatInvitationPagePayload(
          chatName: chat.chatName,
          chatId: chat.chatId,
          prefillAcceptanceContent: payload.rawAcceptanceContent,
        ),
      );
    } catch (_) {
      FuzzzyToast.show(navigatorKey.currentContext!,
          message: _l10n.failedToProcessAcceptance,);
    }
  }

  Future<void> _handleFuzzMessage(
      GoRouter router, FuzzMessageLinkPayload payload,) async {
    try {
      final chat = await _chatRepository.getChatById(payload.chatId);

      if (chat == null) {
        FuzzzyToast.show(navigatorKey.currentContext!,
            message: _l10n.chatNotFoundForMessage,);
        return;
      }

      _navigateCleanly(
        router,
        AppRouter.chatConnected,
        extra: ConnectedChatPagePayload(
          chatGeneralData: chat,
          prefillEncryptedMessage: payload.encryptedMessage,
        ),
      );
    } catch (_) {
      FuzzzyToast.show(navigatorKey.currentContext!,
          message: _l10n.failedToProcessMessage,);
    }
  }

  void _navigateCleanly(GoRouter router, String path, {Object? extra}) {
    router.go(AppRouter.home);
    router.push(path, extra: extra);
  }

  Future<bool> _isAppLocked() async {
    final status = _authStore.state.status;
    return status.isInitial || status.isLocked || status.isUnlocking;
  }

  void dispose() {
    _subscription?.cancel();
  }
}

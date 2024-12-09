import 'package:flutter/material.dart';

import '../ui_kit.dart';

class FuzzyScaffold extends StatelessWidget {
  const FuzzyScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset,
    this.hasSafeAreaOnTop = true,
    this.backgroundColor,
    this.actionsRow,
    this.hasAutomaticBackButton = true,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  final bool? resizeToAvoidBottomInset;
  final bool hasSafeAreaOnTop;
  final Color? backgroundColor;
  final Widget? actionsRow;
  final bool hasAutomaticBackButton;

  @override
  Widget build(BuildContext context) {
    final uiColors = Theme.of(context).extension<UiColors>()!;

    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? uiColors.backgroundPrimaryColor,
      body: Stack(
        children: [
          SafeArea(
            top: hasSafeAreaOnTop,
            child: body,
          ),
          if (hasAutomaticBackButton || actionsRow != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: actionsRow ?? const FuzzyBackButton(),
              ),
            ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

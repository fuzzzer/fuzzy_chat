import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

const Duration _snackBarDisplayDuration = Duration(milliseconds: 4000);

enum UiKitSnackBarType {
  normal,
  reminder,
  failure,
  success,
}

class FuzzySnackBar extends StatefulWidget implements SnackBar {
  final String? label;
  final TextStyle? labelStyle;
  final String? secondaryLabel;
  final TextStyle? secondaryLabelStyle;
  final Widget? leading;
  final Widget? suffixIcon;
  final UiKitSnackBarType type;
  final EdgeInsets? contentPadding;
  final bool? isCentered;
  final VoidCallback? onTap;

  @override
  final Widget content;

  @override
  final Color? backgroundColor;

  @override
  final double? elevation;

  @override
  final EdgeInsetsGeometry? margin;

  @override
  final EdgeInsetsGeometry? padding;

  @override
  final double? width;

  final double? height;

  @override
  final ShapeBorder? shape;

  @override
  final SnackBarBehavior? behavior;

  @override
  final SnackBarAction? action;

  @override
  final Duration duration;

  @override
  final Animation<double>? animation;

  @override
  final VoidCallback? onVisible;

  @override
  final DismissDirection dismissDirection;

  @override
  final Clip clipBehavior;

  const FuzzySnackBar({
    super.key,
    this.label,
    this.labelStyle,
    this.secondaryLabel,
    this.secondaryLabelStyle,
    this.leading,
    this.suffixIcon,
    this.type = UiKitSnackBarType.normal,
    this.contentPadding = const EdgeInsets.all(16),
    this.isCentered = false,
    this.content = const SizedBox.shrink(),
    this.backgroundColor,
    this.elevation = 0,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.shape,
    this.behavior,
    this.action,
    this.duration = _snackBarDisplayDuration,
    this.animation,
    this.onVisible,
    this.dismissDirection = DismissDirection.down,
    this.clipBehavior = Clip.hardEdge,
    this.onTap,
  });

  const FuzzySnackBar.reminder({
    super.key,
    this.label,
    this.labelStyle,
    this.secondaryLabel,
    this.secondaryLabelStyle,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.all(16),
    this.isCentered = false,
    this.content = const SizedBox.shrink(),
    this.elevation = 0,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.shape,
    this.behavior,
    this.action,
    this.duration = _snackBarDisplayDuration,
    this.animation,
    this.onVisible,
    this.dismissDirection = DismissDirection.down,
    this.clipBehavior = Clip.hardEdge,
    this.leading,
    this.backgroundColor,
    this.onTap,
  }) : type = UiKitSnackBarType.reminder;

  const FuzzySnackBar.failure({
    super.key,
    this.label,
    this.labelStyle,
    this.secondaryLabel,
    this.secondaryLabelStyle,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.all(16),
    this.isCentered = false,
    this.content = const SizedBox.shrink(),
    this.elevation = 0,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.shape,
    this.behavior,
    this.action,
    this.duration = _snackBarDisplayDuration,
    this.animation,
    this.onVisible,
    this.dismissDirection = DismissDirection.down,
    this.clipBehavior = Clip.hardEdge,
    this.leading,
    this.backgroundColor,
    this.onTap,
  }) : type = UiKitSnackBarType.failure;

  const FuzzySnackBar.success({
    super.key,
    this.label,
    this.labelStyle,
    this.secondaryLabel,
    this.secondaryLabelStyle,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.all(16),
    this.isCentered = false,
    this.content = const SizedBox.shrink(),
    this.elevation = 0,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.shape,
    this.behavior,
    this.action,
    this.duration = _snackBarDisplayDuration,
    this.animation,
    this.onVisible,
    this.dismissDirection = DismissDirection.down,
    this.clipBehavior = Clip.hardEdge,
    this.leading,
    this.backgroundColor,
    this.onTap,
  }) : type = UiKitSnackBarType.success;

  @override
  SnackBar withAnimation(Animation<double> newAnimation, {Key? fallbackKey}) {
    return FuzzySnackBar(
      key: key ?? fallbackKey,
      label: label,
      secondaryLabel: secondaryLabel,
      secondaryLabelStyle: secondaryLabelStyle,
      type: type,
      labelStyle: labelStyle,
      leading: leading,
      suffixIcon: suffixIcon,
      isCentered: isCentered,
      content: content,
      backgroundColor: backgroundColor,
      elevation: elevation,
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      shape: shape,
      behavior: behavior,
      action: action,
      duration: duration,
      animation: newAnimation,
      onVisible: onVisible,
      dismissDirection: dismissDirection,
      clipBehavior: clipBehavior,
      onTap: onTap,
    );
  }

  @override
  State<FuzzySnackBar> createState() => _FuzzySnackBarState();

  @override
  Color? get closeIconColor => throw UnimplementedError();

  @override
  bool? get showCloseIcon => throw UnimplementedError();

  @override
  double? get actionOverflowThreshold => throw UnimplementedError();

  @override
  HitTestBehavior? get hitTestBehavior => throw UnimplementedError();
}

class _FuzzySnackBarState extends State<FuzzySnackBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;

    return SafeArea(
      child: Align(
        alignment: widget.isCentered! ? Alignment.center : const Alignment(0, -0.9),
        child: SnackBar(
          padding: EdgeInsets.zero,
          behavior: SnackBarBehavior.floating,
          action: widget.action,
          duration: widget.duration,
          animation: widget.animation,
          onVisible: widget.onVisible,
          backgroundColor: Colors.transparent,
          dismissDirection: DismissDirection.up,
          clipBehavior: widget.clipBehavior,
          elevation: widget.elevation,
          content: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(22),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    final onTap = widget.onTap;
                    if (onTap != null) onTap();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? uiColors.secondaryColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(22),
                      ),
                    ),
                    padding: widget.contentPadding,
                    child: Row(
                      children: [
                        if (widget.leading != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: widget.leading,
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: widget.content,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

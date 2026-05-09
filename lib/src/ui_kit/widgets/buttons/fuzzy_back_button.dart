import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';


class FuzzyBackButton extends StatelessWidget {
  const FuzzyBackButton({
    super.key,
    this.onTap,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return FuzzyIconContainerButton(
      icon: Icons.arrow_back,
      onTap: onTap ?? () => context.goBack(),
    );
  }
}

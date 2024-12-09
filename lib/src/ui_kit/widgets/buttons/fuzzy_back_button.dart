import 'package:flutter/material.dart';

import 'fuzzy_icon_container_button.dart';

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
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }
}

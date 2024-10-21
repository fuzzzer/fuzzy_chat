import 'package:flutter/material.dart';

class FuzzyToolbox extends StatelessWidget {
  final List<Widget> children;

  const FuzzyToolbox({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

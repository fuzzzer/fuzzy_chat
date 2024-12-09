import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FuzzyLoadingPagebuilder extends StatelessWidget {
  const FuzzyLoadingPagebuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return const FuzzyScaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
      hasAutomaticBackButton: false,
    );
  }
}

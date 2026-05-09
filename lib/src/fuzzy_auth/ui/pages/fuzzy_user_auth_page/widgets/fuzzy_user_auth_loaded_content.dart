import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FuzzyUserAuthLoadedContent extends StatelessWidget {
  const FuzzyUserAuthLoadedContent({
    super.key,
    required this.item,
  });

  final UserAuthPreferences item;

  @override
  Widget build(BuildContext context) {
    //TODO implement your loaded display for the single item
    return ListTile(
      // TODO: Display your model's data
      title: Text(item.isAuthenticationOnceEnabled.toString()),
      subtitle: Text(currentContextLocalization.lastUpdated),
    );
  }
}

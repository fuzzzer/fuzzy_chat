import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FuzzyUserAuthEmptyContent extends StatelessWidget {
  const FuzzyUserAuthEmptyContent({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO implement your empty display
    return Center(
      child: Text(currentContextLocalization.noDataFoundPleaseSetYourData),
    );
  }
}

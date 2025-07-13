import 'package:flutter/material.dart';

class {{name.pascalCase()}}EmptyContent extends StatelessWidget {
  const {{name.pascalCase()}}EmptyContent({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO implement your empty display
    return const Center(
      child: Text('No items found.'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

class VaultSearchBar extends StatelessWidget {
  const VaultSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: FuzzyTextField(
        labelText: 'Search passwords & notes',
        suffixIcon: const Icon(Icons.search),
        onChanged: (query) {
          context.read<VaultSearchCubit>().updateQuery(query);
        },
      ),
    );
  }
}

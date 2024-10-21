import 'package:flutter/material.dart';

enum FilterStateStatus {
  initial,
  loading,
  filtered;

  bool get isInitial => this == FilterStateStatus.initial;
  bool get isLoading => this == FilterStateStatus.loading;
  bool get isFiltered => this == FilterStateStatus.filtered;
}

class FilterStateStatusBuilder {
  FilterStateStatusBuilder._();

  static Widget buildByStatus({
    required FilterStateStatus status,
    required Widget Function() onInitial,
    required Widget Function() onLoading,
    required Widget Function() onFiltered,
  }) {
    if (status.isInitial) {
      return onInitial();
    }

    if (status.isLoading) {
      return onLoading();
    }

    if (status.isFiltered) {
      return onFiltered();
    }

    return Container();
  }
}

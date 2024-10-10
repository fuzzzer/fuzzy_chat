import 'package:flutter/material.dart';

enum OptimisticStateStatus {
  initial,
  updated,
  success,
  failedAndReverted;

  bool get isInitial => this == OptimisticStateStatus.initial;
  bool get isUpdated => this == OptimisticStateStatus.updated;
  bool get isSuccess => this == OptimisticStateStatus.success;
  bool get isFailed => this == OptimisticStateStatus.failedAndReverted;
}

class OptimisticStatusBuilder {
  OptimisticStatusBuilder._();

  static Widget buildByStatus({
    required OptimisticStateStatus status,
    required Widget Function() onInitial,
    required Widget Function() onUpdated,
    required Widget Function() onSuccess,
    required Widget Function()? onFailure,
  }) {
    if (status == OptimisticStateStatus.initial) {
      return onInitial();
    }

    if (status == OptimisticStateStatus.updated) {
      return onUpdated();
    }

    if (status == OptimisticStateStatus.success) {
      return onSuccess();
    }

    if (status == OptimisticStateStatus.failedAndReverted && onFailure != null) {
      return onFailure();
    }

    return Container();
  }
}

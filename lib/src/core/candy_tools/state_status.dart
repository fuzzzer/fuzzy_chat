import 'package:flutter/material.dart';

enum StateStatus {
  initial,
  loading,
  success,
  failed;

  bool get isInitial => this == StateStatus.initial;
  bool get isLoading => this == StateStatus.loading;
  bool get isSuccess => this == StateStatus.success;
  bool get isFailed => this == StateStatus.failed;
}

class StatusBuilder {
  StatusBuilder._();

  static Widget buildByStatus({
    required StateStatus status,
    required Widget Function() onInitial,
    required Widget Function() onLoading,
    required Widget Function() onSuccess,
    required Widget Function()? onFailure,
  }) {
    if (status == StateStatus.initial) {
      return onInitial();
    }

    if (status == StateStatus.loading) {
      return onLoading();
    }

    if (status == StateStatus.success) {
      return onSuccess();
    }

    if (status == StateStatus.failed && onFailure != null) {
      return onFailure();
    }

    return Container();
  }
}

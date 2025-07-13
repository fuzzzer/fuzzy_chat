enum AuthStateStatus {
  initial,
  authenticated;

  bool get isInitial => this == initial;
  bool get isAuthenticated => this == authenticated;
}

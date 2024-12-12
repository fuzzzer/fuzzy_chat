part of 'localization_cubit.dart';

class LocalizationState {
  final Locale locale;

  LocalizationState({
    required this.locale,
  });

  LocalizationState copyWith({
    Locale? locale,
  }) {
    return LocalizationState(
      locale: locale ?? this.locale,
    );
  }

  @override
  String toString() => 'LocalizationState(locale: $locale)';

  @override
  bool operator ==(covariant LocalizationState other) {
    if (identical(this, other)) return true;

    return other.locale == locale;
  }

  @override
  int get hashCode => locale.hashCode;
}

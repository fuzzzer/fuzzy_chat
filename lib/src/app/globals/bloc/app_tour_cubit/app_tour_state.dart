part of 'app_tour_cubit.dart';

class AppTourState {
  final bool tourShown;

  AppTourState({
    required this.tourShown,
  });

  AppTourState copyWith({
    bool? tourShown,
  }) {
    return AppTourState(
      tourShown: tourShown ?? this.tourShown,
    );
  }
}

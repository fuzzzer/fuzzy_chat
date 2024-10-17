import 'dart:async';
import 'package:get_it/get_it.dart';

export 'impl/impl.dart';
export 'impl/service_locator_getit.dart';

abstract class ServiceLocator {
  void registerFactory<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
  });

  void registerLazySingleton<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
    DisposingFunc<T>? dispose,
  });

  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
  });

  FutureOr<dynamic> unregister<T extends Object>({
    Object? instance,
    String? instanceName,
    FutureOr<dynamic> Function(T)? disposingFunction,
  });

  bool isRegistered<T extends Object>({
    Object? instance,
    String? instanceName,
  });

  T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  });

  Future<T> getAsync<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  });

  void safeRegisterSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
  });
}

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view_model/locale_view_model.dart';

class ServiceLocator {
  static ServiceLocator instance = ServiceLocator._();
  final GetIt _getIt = GetIt.asNewInstance();

  ServiceLocator._();

  Future<void> initialise() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    registerSingletonIfNeeded(sharedPrefs);
    registerSingletonIfNeeded(LocateViewModel());
  }

  void registerSingletonIfNeeded<T extends Object>(T instance) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerSingleton<T>(instance);
    }
  }

  void reset() => _getIt.reset();

  T get<T extends Object>() {
    return _getIt.get<T>();
  }
}

import '../../storage/local_data_sources/user_auth_preferences_local_data_source.dart';
import '../models/user_auth_preferences.dart';

class UserAuthPreferencesRepository {
  final UserAuthPreferencesLocalDataSource localDataSource;

  UserAuthPreferencesRepository({required this.localDataSource});

  Future<UserAuthPreferences?> getUserAuthPreferences() async {
    final storedItem = await localDataSource.get();
    if (storedItem != null) {
      return UserAuthPreferences.fromStored(storedItem);
    }
    return null;
  }

  Future<void> updateUserAuthPreferences(UserAuthPreferences item) async {
    await localDataSource.update(item);
  }

  Future<void> deleteUserAuthPreferences() async {
    await localDataSource.delete();
  }
}

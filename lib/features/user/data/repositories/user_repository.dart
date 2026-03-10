import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/features/user/data/models/user_model.dart';

/// 用户仓库
abstract class UserRepository {
  Future<UserModel?> getCurrentUser();
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser();
  Future<UserSettingsModel?> getSettings();
  Future<void> saveSettings(UserSettingsModel settings);
}

/// 用户仓库实现
class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserModel?> getCurrentUser() async => null;

  @override
  Future<void> saveUser(UserModel user) async {}

  @override
  Future<void> deleteUser() async {}

  @override
  Future<UserSettingsModel?> getSettings() async => const UserSettingsModel();

  @override
  Future<void> saveSettings(UserSettingsModel settings) async {}
}

/// 用户仓库 Provider
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(),
);

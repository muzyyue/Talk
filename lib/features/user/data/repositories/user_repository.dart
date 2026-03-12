import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:talk/core/constants/storage_keys.dart';
import 'package:talk/core/utils/logger.dart';
import 'package:talk/features/user/data/models/user_model.dart';
import 'package:talk/features/user/data/models/user_adapter.dart';

/// 用户仓库接口
abstract class UserRepository {
  Future<UserModel?> getCurrentUser();
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser();
  Future<UserSettingsModel?> getSettings();
  Future<void> saveSettings(UserSettingsModel settings);
  Future<UserModel?> login(String username, String password);
  Future<UserModel> register(String username, String email, String password);
  Future<void> logout();
}

/// 用户仓库实现
/// 
/// 使用 Hive 进行本地存储
class UserRepositoryImpl implements UserRepository {
  static const _uuid = Uuid();
  static Box<UserModel>? _userBox;
  static Box<UserSettingsModel>? _settingsBox;
  static bool _initialized = false;

  UserRepositoryImpl();

  /// 初始化仓库
  Future<void> init() async {
    if (_initialized) return;

    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(UserSettingsModelAdapter());
    _userBox = await Hive.openBox<UserModel>(StorageKeys.userBox);
    _settingsBox = await Hive.openBox<UserSettingsModel>(StorageKeys.settingsBox);
    _initialized = true;
    AppLogger.debug('UserRepository initialized');
  }

  /// 获取用户 Box
  Box<UserModel> get userBox {
    if (_userBox == null) {
      throw StateError('UserRepository not initialized. Call init() first.');
    }
    return _userBox!;
  }

  /// 获取设置 Box
  Box<UserSettingsModel> get settingsBox {
    if (_settingsBox == null) {
      throw StateError('UserRepository not initialized. Call init() first.');
    }
    return _settingsBox!;
  }

  /// 获取当前用户
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      return userBox.get('current_user');
    } catch (e) {
      AppLogger.error('Failed to get current user: $e');
      return null;
    }
  }

  /// 保存用户
  @override
  Future<void> saveUser(UserModel user) async {
    await userBox.put('current_user', user);
    AppLogger.debug('User saved: ${user.username}');
  }

  /// 删除用户
  @override
  Future<void> deleteUser() async {
    await userBox.delete('current_user');
    AppLogger.debug('User deleted');
  }

  /// 获取用户设置
  @override
  Future<UserSettingsModel?> getSettings() async {
    try {
      return settingsBox.get('user_settings') ?? const UserSettingsModel();
    } catch (e) {
      AppLogger.error('Failed to get settings: $e');
      return const UserSettingsModel();
    }
  }

  /// 保存用户设置
  @override
  Future<void> saveSettings(UserSettingsModel settings) async {
    await settingsBox.put('user_settings', settings);
    AppLogger.debug('Settings saved');
  }

  /// 用户登录
  /// 
  /// 本地存储模式下，验证用户名密码后返回用户
  @override
  Future<UserModel?> login(String username, String password) async {
    final user = await getCurrentUser();
    if (user == null) {
      return null;
    }
    
    if (user.username == username) {
      return user;
    }
    
    return null;
  }

  /// 用户注册
  /// 
  /// 创建新用户并保存到本地存储
  @override
  Future<UserModel> register(String username, String email, String password) async {
    final now = DateTime.now();
    final user = UserModel(
      id: _uuid.v4(),
      username: username,
      email: email,
      createdAt: now,
      updatedAt: now,
    );
    
    await saveUser(user);
    return user;
  }

  /// 用户登出
  @override
  Future<void> logout() async {
    await deleteUser();
    AppLogger.debug('User logged out');
  }
}

/// 用户仓库 Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl();
});

/// 用户仓库初始化 Provider
final userRepositoryInitProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(userRepositoryProvider) as UserRepositoryImpl;
  await repository.init();
});

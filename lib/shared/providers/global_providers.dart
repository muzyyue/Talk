import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:talk/shared/providers/global_init_provider.dart';

export 'package:talk/shared/providers/global_init_provider.dart';

/// 主题模式 Provider
/// 
/// 管理应用主题模式（亮色/暗色）
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

/// 主题模式状态管理
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  /// 设置主题模式
  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  /// 切换主题模式
  void toggleThemeMode() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  /// 是否为暗色模式
  bool get isDarkMode => state == ThemeMode.dark;
}

/// 用户 Provider
/// 
/// 管理用户登录状态
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>(
  (ref) => UserNotifier(),
);

/// 用户状态管理
class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  UserNotifier() : super(const AsyncValue.data(null));

  /// 登录
  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1));
      state = AsyncValue.data(User(
        id: '1',
        username: username,
        email: '$username@example.com',
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 登出
  Future<void> logout() async {
    state = const AsyncValue.data(null);
  }

  /// 更新用户信息
  void updateUser(User user) {
    state = AsyncValue.data(user);
  }

  /// 是否已登录
  bool get isLoggedIn => state.value != null;
}

/// 用户模型
class User {
  final String id;
  final String username;
  final String email;
  final String? avatar;
  final String? nickname;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    this.nickname,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? avatar,
    String? nickname,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      nickname: nickname ?? this.nickname,
    );
  }
}

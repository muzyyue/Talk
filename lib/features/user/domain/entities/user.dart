/// 用户实体
class User {
  final String id;
  final String username;
  final String email;
  final String? avatar;
  final String? nickname;
  final String? bio;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    this.nickname,
    this.bio,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? avatar,
    String? nickname,
    String? bio,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      nickname: nickname ?? this.nickname,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// 用户设置实体
class UserSettings {
  final String locale;
  final String themeMode;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const UserSettings({
    this.locale = 'zh',
    this.themeMode = 'system',
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });
}

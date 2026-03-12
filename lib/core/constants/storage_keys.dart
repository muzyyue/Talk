/// 本地存储键值定义
/// 
/// 定义 Hive 存储的 Box 名称和键值
class StorageKeys {
  StorageKeys._();

  static const String userBox = 'user_box';
  static const String characterCardsBox = 'character_cards_box';
  static const String chatSessionsBox = 'chat_sessions_box';
  static const String relationshipsBox = 'relationships_box';
  static const String storiesBox = 'stories_box';
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';
  static const String apiConfigBox = 'api_config_box';

  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String themeModeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String lastSyncTimeKey = 'last_sync_time';
  static const String apiConfigKey = 'api_config';
}

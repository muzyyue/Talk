/// 应用常量定义
/// 
/// 包含应用名称、版本、默认配置等全局常量
class AppConstants {
  AppConstants._();

  static const String appName = '星语物语';
  static const String appNameEn = 'StarTale';
  static const String appVersion = '1.0.0';
  
  static const int defaultPageSize = 20;
  static const int maxRetryCount = 3;
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  static const int maxMessageHistory = 100;
  static const int maxCharacterCards = 50;
  
  static const double minAffection = 0;
  static const double maxAffection = 100;
}

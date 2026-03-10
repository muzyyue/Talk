/// API 相关常量定义
/// 
/// 包含 API 地址、端点、请求头等配置
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.startale.app';
  static const String apiVersion = 'v1';
  
  static const String authEndpoint = '/auth';
  static const String userEndpoint = '/user';
  static const String characterEndpoint = '/character';
  static const String chatEndpoint = '/chat';
  static const String storyEndpoint = '/story';
  
  static const String contentType = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  
  static const Map<String, String> defaultHeaders = {
    'Content-Type': contentType,
    'Accept': contentType,
  };
}

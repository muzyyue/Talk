import 'package:logger/logger.dart';

/// 应用日志工具
/// 
/// 提供统一的日志输出接口
/// 支持不同级别的日志输出和格式化
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static final Logger _simpleLogger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// 调试日志
  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// 信息日志
  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// 警告日志
  static void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// 错误日志
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// 致命错误日志
  static void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// 追踪日志
  static void trace(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// 简单日志（无堆栈信息）
  static void log(dynamic message) {
    _simpleLogger.i(message);
  }

  /// 网络请求日志
  static void networkRequest(String method, String url, [Map<String, dynamic>? data]) {
    _simpleLogger.i('🌐 $method $url ${data != null ? '\n$data' : ''}');
  }

  /// 网络响应日志
  static void networkResponse(String url, int statusCode, [dynamic data]) {
    final emoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    _simpleLogger.i('$emoji $url [$statusCode] ${data != null ? '\n$data' : ''}');
  }

  /// 性能日志
  static void performance(String operation, Duration duration) {
    _simpleLogger.i('⏱️ $operation took ${duration.inMilliseconds}ms');
  }
}

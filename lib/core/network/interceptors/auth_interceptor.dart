import 'package:dio/dio.dart';
import 'package:talk/core/constants/api_constants.dart';
import 'package:talk/core/storage/secure_storage.dart';

/// 认证拦截器
/// 
/// 自动添加 Token 到请求头
/// 处理 Token 过期和刷新
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage.instance.read(ApiConstants.tokenKey);
    if (token != null) {
      options.headers[ApiConstants.authorizationHeader] =
          '${ApiConstants.bearerPrefix}$token';
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await SecureStorage.instance.read(ApiConstants.refreshTokenKey);
      if (refreshToken != null) {
        try {
          final newToken = await _refreshToken(refreshToken);
          await SecureStorage.instance.write(ApiConstants.tokenKey, newToken);
          err.requestOptions.headers[ApiConstants.authorizationHeader] =
              '${ApiConstants.bearerPrefix}$newToken';
          final response = await _retry(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          await SecureStorage.instance.delete(ApiConstants.tokenKey);
          await SecureStorage.instance.delete(ApiConstants.refreshTokenKey);
        }
      }
    }
    handler.next(err);
  }

  Future<String> _refreshToken(String refreshToken) async {
    final response = await Dio().post(
      '${ApiConstants.baseUrl}${ApiConstants.authEndpoint}/refresh',
      data: {'refresh_token': refreshToken},
    );
    return response.data['data']['token'];
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final dio = Dio();
    return dio.fetch(requestOptions);
  }
}

/// 错误处理拦截器
/// 
/// 统一处理网络错误和服务器错误
class ErrorInterceptor extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    String errorMessage = '未知错误';

    if (err.response?.data != null) {
      final data = err.response!.data;
      if (data is Map && data['message'] != null) {
        errorMessage = data['message'];
      }
    }

    err = err.copyWith(
      message: errorMessage,
    );

    handler.next(err);
  }
}

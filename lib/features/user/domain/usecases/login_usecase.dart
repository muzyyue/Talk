import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/features/user/domain/entities/user.dart';

/// 登录用例
class LoginUseCase {
  Future<User> call(LoginParams params) async {
    return User(
      id: '1',
      username: params.username,
      email: '${params.username}@example.com',
      createdAt: DateTime.now(),
    );
  }
}

/// 登录参数
class LoginParams {
  final String username;
  final String password;

  const LoginParams({
    required this.username,
    required this.password,
  });
}

/// 登录用例 Provider
final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/features/user/domain/entities/user.dart';
import 'package:talk/features/user/domain/usecases/login_usecase.dart';

/// 用户状态
class UserState {
  final User? user;
  final bool isLoading;
  final String? error;

  const UserState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isLoggedIn => user != null;
}

/// 用户状态管理
class UserNotifier extends StateNotifier<UserState> {
  final LoginUseCase _loginUseCase;

  UserNotifier(this._loginUseCase) : super(const UserState());

  Future<void> login(String username, String password) async {
    state = const UserState(isLoading: true);
    try {
      final user = await _loginUseCase(LoginParams(
        username: username,
        password: password,
      ));
      state = UserState(user: user);
    } catch (e) {
      state = UserState(error: e.toString());
    }
  }

  void logout() {
    state = const UserState();
  }
}

/// 用户 Provider
final userStateProvider =
    StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(ref.watch(loginUseCaseProvider)),
);

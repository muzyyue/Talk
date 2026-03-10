import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/core/constants/constants.dart';
import 'package:talk/core/theme/theme.dart';
import 'package:talk/features/character_card/presentation/pages/character_card_list_page.dart';
import 'package:talk/features/character_card/presentation/pages/character_card_detail_page.dart';
import 'package:talk/features/character_card/presentation/pages/character_card_create_page.dart';
import 'package:talk/features/character_card/presentation/pages/character_card_import_page.dart';
import 'package:talk/features/character_card/domain/usecases/get_character_cards_usecase.dart';
import 'package:talk/features/dialogue/presentation/pages/chat_page.dart';
import 'package:talk/shared/widgets/common_widgets.dart';

/// 应用路由定义
/// 
/// 定义所有路由路径常量
class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String home = '/home';
  static const String main = '/main';

  static const String login = '/login';
  static const String register = '/register';

  static const String characterCardList = '/character-cards';
  static const String characterCardDetail = '/character-cards/:id';
  static const String characterCardCreate = '/character-cards/create';
  static const String characterCardEdit = '/character-cards/:id/edit';
  static const String characterCardImport = '/character-cards/import';

  static const String chat = '/chat/:characterCardId';
  static const String chatHistory = '/chat/history';

  static const String storyList = '/stories';
  static const String storyDetail = '/stories/:id';

  static const String settings = '/settings';
  static const String profile = '/profile';
}

/// 角色卡详情 Provider
final characterCardDetailProvider = FutureProvider.family((ref, String id) async {
  final useCase = ref.watch(getCharacterCardDetailUseCaseProvider);
  return await useCase(id);
});

/// 路由配置 Provider
/// 
/// 提供 GoRouter 实例
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.main,
            name: 'main',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.characterCardList,
            name: 'characterCardList',
            builder: (context, state) => const CharacterCardListPage(),
            routes: [
              GoRoute(
                path: 'create',
                name: 'characterCardCreate',
                builder: (context, state) => const CharacterCardCreatePage(),
              ),
              GoRoute(
                path: 'import',
                name: 'characterCardImport',
                builder: (context, state) => const CharacterCardImportPage(),
              ),
              GoRoute(
                path: ':id',
                name: 'characterCardDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return CharacterCardDetailPage(characterCardId: id);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'characterCardEdit',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return CharacterCardEditPage(characterCardId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.chatHistory,
            name: 'chatHistory',
            builder: (context, state) => const ChatHistoryPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.chat,
        name: 'chat',
        builder: (context, state) {
          final characterCardId = state.pathParameters['characterCardId']!;
          return ChatPage(characterCardId: characterCardId);
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
    redirect: (context, state) async {
      return null;
    },
  );
});

/// 启动页
/// 
/// 应用启动时显示的加载页面
/// 初始化完成后自动跳转到主页
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  /// 延迟后跳转到主页
  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                AppConstants.appName,
                style: AppTextStyles.h1.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

/// 登录页
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('登录页'),
      ),
    );
  }
}

/// 注册页
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('注册页'),
      ),
    );
  }
}

/// 主页面外壳
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}

/// 底部导航栏
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _calculateSelectedIndex(context),
      onDestinationSelected: (index) => _onItemTapped(index, context),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: '首页',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: '角色',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble),
          label: '对话',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_pin_outlined),
          selectedIcon: Icon(Icons.person_pin),
          label: '我的',
        ),
      ],
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.home) || location == AppRoutes.main) {
      return 0;
    }
    if (location.startsWith(AppRoutes.characterCardList)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.chat) || location == AppRoutes.chatHistory) {
      return 2;
    }
    if (location.startsWith(AppRoutes.profile)) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.characterCardList);
        break;
      case 2:
        context.go(AppRoutes.chatHistory);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }
}

/// 首页
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('星语物语'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryContainer.withValues(alpha: 0.3),
              AppColors.background,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                '欢迎使用星语物语',
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 8),
              Text(
                '创建角色卡，开始你的虚拟社交之旅',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              GradientButton(
                text: '创建角色卡',
                onPressed: () => context.push(AppRoutes.characterCardCreate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 角色卡编辑页
class CharacterCardEditPage extends StatelessWidget {
  final String characterCardId;

  const CharacterCardEditPage({super.key, required this.characterCardId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑角色卡'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('编辑角色卡: $characterCardId'),
      ),
    );
  }
}

/// 对话历史页
class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('对话历史'),
        centerTitle: true,
      ),
      body: const EmptyState(
        icon: Icon(Icons.chat_bubble_outline, size: 64),
        title: '还没有对话',
        message: '选择一个角色卡开始对话吧',
      ),
    );
  }
}

/// 个人中心页
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人中心'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('设置'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.settings),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

/// 设置页
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('主题'),
            subtitle: const Text('跟随系统'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('语言'),
            subtitle: const Text('简体中文'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('清除缓存'),
            subtitle: const Text('0 MB'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

/// 错误页
class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                '页面不存在',
                style: AppTextStyles.h2,
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              GradientButton(
                text: '返回首页',
                onPressed: () => context.go(AppRoutes.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

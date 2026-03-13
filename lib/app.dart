import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/core/core.dart';
import 'package:talk/core/router/router.dart';
import 'package:talk/shared/providers/global_providers.dart';

/// 星语物语应用
/// 
/// 应用根组件，配置主题、路由、国际化等
class StarTaleApp extends ConsumerStatefulWidget {
  const StarTaleApp({super.key});

  @override
  ConsumerState<StarTaleApp> createState() => _StarTaleAppState();
}

class _StarTaleAppState extends ConsumerState<StarTaleApp> {
  @override
  void initState() {
    super.initState();
    // 触发全局初始化（包括角色卡仓库）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(globalInitProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

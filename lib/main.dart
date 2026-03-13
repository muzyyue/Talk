import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/core/core.dart';
import 'package:talk/app.dart';

/// 应用入口函数
/// 
/// 初始化应用并启动
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeApp();

  runApp(
    ProviderScope(
      child: StarTaleApp(),
    ),
  );
}

/// 初始化应用
/// 
/// 初始化存储、网络等基础设施
Future<void> _initializeApp() async {
  await LocalStorage.instance.init();
  SecureStorage.instance.init();
  ApiClient.instance.init();
}

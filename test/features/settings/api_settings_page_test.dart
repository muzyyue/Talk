import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talk/core/config/api_config_model.dart';
import 'package:talk/core/services/ai_service.dart';
import 'package:talk/features/settings/presentation/pages/api_settings_page.dart';

Widget createTestWidget(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  group('APISettingsPage', () {
    testWidgets('页面正确渲染标题', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      expect(find.text('API 设置'), findsOneWidget);
    });

    testWidgets('页面包含服务提供商选择器', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      expect(find.text('服务提供商'), findsOneWidget);
      expect(find.text('模拟服务 (测试用)'), findsOneWidget);
      expect(find.text('LM Studio (本地)'), findsOneWidget);
      expect(find.text('OpenAI'), findsOneWidget);
      expect(find.text('自定义 API'), findsOneWidget);
    });

    testWidgets('选择 LM Studio 显示 API 地址输入框', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      await tester.tap(find.text('LM Studio (本地)'));
      await tester.pumpAndSettle();

      expect(find.text('API 地址'), findsOneWidget);
    });

    testWidgets('选择 OpenAI 显示 API Key 输入框', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      await tester.tap(find.text('OpenAI'));
      await tester.pumpAndSettle();

      expect(find.text('API Key'), findsOneWidget);
    });

    testWidgets('选择 Mock 隐藏 API 配置输入框', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      await tester.tap(find.text('模拟服务 (测试用)'));
      await tester.pumpAndSettle();

      expect(find.text('API 地址'), findsNothing);
    });

    testWidgets('页面包含温度滑块', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      expect(find.text('温度 (Temperature)'), findsOneWidget);
    });

    testWidgets('页面包含最大 Token 数输入框', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      expect(find.text('最大 Token 数'), findsOneWidget);
    });

    testWidgets('页面包含流式输出开关', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      expect(find.text('流式输出'), findsOneWidget);
    });

    testWidgets('页面包含请求超时输入框', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      expect(find.text('请求超时 (秒)'), findsOneWidget);
    });

    testWidgets('页面包含测试连接按钮', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      expect(find.text('测试连接'), findsOneWidget);
    });

    testWidgets('页面包含使用说明', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      expect(find.text('使用说明'), findsOneWidget);
    });

    testWidgets('选择 LM Studio 显示 LM Studio 使用说明', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      await tester.tap(find.text('LM Studio (本地)'));
      await tester.pumpAndSettle();

      expect(find.text('1. 下载并安装 LM Studio'), findsOneWidget);
      expect(find.text('2. 在 LM Studio 中加载模型'), findsOneWidget);
      expect(find.text('3. 启动本地服务器 (默认端口 1234)'), findsOneWidget);
      expect(find.text('4. 确保 LM Studio 正在运行'), findsOneWidget);
    });

    testWidgets('选择 Mock 显示模拟服务说明', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      await tester.tap(find.text('模拟服务 (测试用)'));
      await tester.pumpAndSettle();

      expect(find.text('模拟服务用于测试应用功能'), findsOneWidget);
      expect(find.text('返回预设的模拟响应'), findsOneWidget);
      expect(find.text('无需配置即可使用'), findsOneWidget);
    });

    testWidgets('保存按钮存在', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      expect(find.text('保存'), findsOneWidget);
    });

    testWidgets('温度滑块默认值为 0.8', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      expect(find.text('0.80'), findsOneWidget);
    });

    testWidgets('模型输入框存在', (tester) async {
      await tester.pumpWidget(createTestWidget(const APISettingsPage()));

      await tester.tap(find.text('LM Studio (本地)'));
      await tester.pumpAndSettle();

      expect(find.text('模型'), findsOneWidget);
    });
  });

  group('APIConfigModel Provider', () {
    test('默认配置为 Mock 类型', () {
      final container = ProviderContainer();
      final config = container.read(apiConfigProvider);

      expect(config.provider, APIProviderType.mock);
      container.dispose();
    });

    test('可以更新配置', () {
      final container = ProviderContainer();
      
      container.read(apiConfigProvider.notifier).state = const APIConfigModel(
        provider: APIProviderType.lmStudio,
        baseUrl: 'http://localhost:8080',
      );

      final config = container.read(apiConfigProvider);
      expect(config.provider, APIProviderType.lmStudio);
      expect(config.baseUrl, 'http://localhost:8080');
      
      container.dispose();
    });
  });

  group('AIService Provider', () {
    test('根据配置返回正确的服务实例', () {
      final container = ProviderContainer();
      
      container.read(apiConfigProvider.notifier).state = const APIConfigModel(
        provider: APIProviderType.mock,
      );
      
      final service = container.read(aiServiceProvider);
      expect(service, isA<MockAIService>());
      
      container.dispose();
    });

    test('切换配置后服务实例更新', () {
      final container = ProviderContainer();
      
      container.read(apiConfigProvider.notifier).state = const APIConfigModel(
        provider: APIProviderType.mock,
      );
      expect(container.read(aiServiceProvider), isA<MockAIService>());
      
      container.read(apiConfigProvider.notifier).state = const APIConfigModel(
        provider: APIProviderType.lmStudio,
        baseUrl: 'http://localhost:1234',
      );
      expect(container.read(aiServiceProvider), isA<LMStudioAIService>());
      
      container.dispose();
    });
  });
}

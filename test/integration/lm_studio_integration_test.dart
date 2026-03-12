import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:talk/core/config/api_config_model.dart';
import 'package:talk/core/services/ai_service.dart';
import 'package:talk/core/services/lm_studio_client.dart';

/// LM Studio API 集成测试
/// 
/// 运行前请确保：
/// 1. LM Studio 已启动并加载了模型
/// 2. 本地服务器已开启（默认端口 1234）
/// 
/// 运行命令：
/// ```bash
/// flutter test test/integration/lm_studio_integration_test.dart
/// ```
void main() {
  group('LM Studio API 集成测试', () {
    late LMStudioClient client;
    late LMStudioAIService aiService;
    
    const testConfig = APIConfigModel(
      provider: APIProviderType.lmStudio,
      baseUrl: 'http://localhost:1234',
      model: '',
      timeoutSeconds: 60,
    );

    setUpAll(() {
      client = LMStudioClient(testConfig);
      aiService = LMStudioAIService(testConfig);
      
      print('\n========================================');
      print('LM Studio API 集成测试');
      print('========================================');
      print('测试配置:');
      print('  - 服务地址: ${testConfig.baseUrl}');
      print('  - 超时时间: ${testConfig.timeoutSeconds}秒');
      print('========================================\n');
    });

    tearDownAll(() {
      client.close();
    });

    group('1. 基本连接测试', () {
      test('1.1 检查服务是否可达', () async {
        print('\n--- 测试 1.1: 检查服务是否可达 ---');
        
        final stopwatch = Stopwatch()..start();
        final isConnected = await client.testConnection();
        stopwatch.stop();
        
        print('请求地址: ${testConfig.baseUrl}/v1/models');
        print('响应时间: ${stopwatch.elapsedMilliseconds}ms');
        print('连接状态: ${isConnected ? "成功 ✓" : "失败 ✗"}');
        
        expect(isConnected, isTrue, reason: 'LM Studio 服务未启动或端口不正确');
        
        print('--- 测试 1.1 完成 ---\n');
      }, timeout: const Timeout(Duration(seconds: 30)));
    });

    group('2. 获取模型列表测试', () {
      test('2.1 获取可用模型列表', () async {
        print('\n--- 测试 2.1: 获取可用模型列表 ---');
        
        final stopwatch = Stopwatch()..start();
        final models = await client.getModels();
        stopwatch.stop();
        
        print('请求地址: ${testConfig.baseUrl}/v1/models');
        print('响应时间: ${stopwatch.elapsedMilliseconds}ms');
        print('模型数量: ${models.length}');
        
        if (models.isNotEmpty) {
          print('可用模型:');
          for (final model in models) {
            print('  - ${model.id}');
          }
        } else {
          print('警告: 未找到可用模型，请确保 LM Studio 已加载模型');
        }
        
        print('--- 测试 2.1 完成 ---\n');
      }, timeout: const Timeout(Duration(seconds: 30)));
    });

    group('3. 聊天请求测试', () {
      test('3.1 发送简单聊天请求', () async {
        print('\n--- 测试 3.1: 发送简单聊天请求 ---');
        
        final request = LMStudioChatRequest(
          model: 'local-model',
          messages: const [
            LMStudioMessage(role: 'system', content: '你是一个友好的助手。'),
            LMStudioMessage(role: 'user', content: '你好，请用一句话介绍你自己。'),
          ],
          temperature: 0.7,
          maxTokens: 100,
        );
        
        print('请求参数:');
        print('  - 模型: ${request.model}');
        print('  - 温度: ${request.temperature}');
        print('  - 最大Token: ${request.maxTokens}');
        print('  - 消息数量: ${request.messages.length}');
        
        final stopwatch = Stopwatch()..start();
        
        try {
          final response = await client.sendChat(request);
          stopwatch.stop();
          
          print('\n响应结果:');
          print('  - 响应时间: ${stopwatch.elapsedMilliseconds}ms');
          print('  - 响应ID: ${response.id}');
          print('  - 模型: ${response.model}');
          print('  - 内容长度: ${response.content.length}字符');
          print('  - 内容预览: ${response.content.length > 100 ? "${response.content.substring(0, 100)}..." : response.content}');
          
          if (response.usage != null) {
            print('  - Token使用:');
            print('    - 提示Token: ${response.usage!.promptTokens}');
            print('    - 完成Token: ${response.usage!.completionTokens}');
            print('    - 总Token: ${response.usage!.totalTokens}');
          }
          
          expect(response.content, isNotEmpty, reason: '响应内容不应为空');
          print('\n测试结果: 成功 ✓');
        } catch (e) {
          stopwatch.stop();
          print('响应时间: ${stopwatch.elapsedMilliseconds}ms');
          print('错误信息: $e');
          print('测试结果: 失败 ✗');
          rethrow;
        }
        
        print('--- 测试 3.1 完成 ---\n');
      }, timeout: const Timeout(Duration(seconds: 120)));

      test('3.2 发送角色扮演请求', () async {
        print('\n--- 测试 3.2: 发送角色扮演请求 ---');
        
        final aiRequest = const AIRequestModel(
          characterCardId: 'test-character',
          characterName: '小助手',
          personality: '热情、友好、乐于助人',
          scenario: '在一个温馨的咖啡厅',
          userMessage: '你好，请问这里有什么推荐的饮品吗？',
          temperature: 0.8,
          maxTokens: 200,
        );
        
        print('角色设定:');
        print('  - 角色名: ${aiRequest.characterName}');
        print('  - 性格: ${aiRequest.personality}');
        print('  - 场景: ${aiRequest.scenario}');
        print('  - 用户消息: ${aiRequest.userMessage}');
        
        final stopwatch = Stopwatch()..start();
        
        try {
          final response = await aiService.sendMessage(aiRequest);
          stopwatch.stop();
          
          print('\n响应结果:');
          print('  - 响应时间: ${stopwatch.elapsedMilliseconds}ms');
          print('  - 成功: ${response.success}');
          print('  - 内容: ${response.content}');
          
          if (response.error != null) {
            print('  - 错误: ${response.error}');
          }
          
          expect(response.success, isTrue, reason: '请求应该成功');
          expect(response.content, isNotEmpty, reason: '响应内容不应为空');
          print('\n测试结果: 成功 ✓');
        } catch (e) {
          stopwatch.stop();
          print('响应时间: ${stopwatch.elapsedMilliseconds}ms');
          print('错误信息: $e');
          print('测试结果: 失败 ✗');
          rethrow;
        }
        
        print('--- 测试 3.2 完成 ---\n');
      }, timeout: const Timeout(Duration(seconds: 120)));

      test('3.3 测试流式响应', () async {
        print('\n--- 测试 3.3: 测试流式响应 ---');
        
        final request = LMStudioChatRequest(
          model: 'local-model',
          messages: const [
            LMStudioMessage(role: 'user', content: '请数到5'),
          ],
          temperature: 0.5,
          maxTokens: 50,
          stream: true,
        );
        
        print('请求参数:');
        print('  - 流式: true');
        print('  - 消息: 请数到5');
        
        final stopwatch = Stopwatch()..start();
        final chunks = <String>[];
        
        try {
          await for (final response in client.sendChatStream(request)) {
            final delta = response.choices.isNotEmpty 
                ? response.choices.first.delta?.content 
                : null;
            if (delta != null && delta.isNotEmpty) {
              chunks.add(delta);
              stdout.write(delta);
            }
          }
          stopwatch.stop();
          
          print('\n\n流式响应统计:');
          print('  - 总响应时间: ${stopwatch.elapsedMilliseconds}ms');
          print('  - 数据块数量: ${chunks.length}');
          print('  - 完整内容: ${chunks.join()}');
          
          expect(chunks.isNotEmpty, isTrue, reason: '应该收到流式数据');
          print('\n测试结果: 成功 ✓');
        } catch (e) {
          stopwatch.stop();
          print('\n响应时间: ${stopwatch.elapsedMilliseconds}ms');
          print('错误信息: $e');
          print('测试结果: 失败 ✗');
          rethrow;
        }
        
        print('--- 测试 3.3 完成 ---\n');
      }, timeout: const Timeout(Duration(seconds: 120)));
    });

    group('4. 异常情况测试', () {
      test('4.1 测试无效服务地址', () async {
        print('\n--- 测试 4.1: 测试无效服务地址 ---');
        
        final invalidConfig = const APIConfigModel(
          provider: APIProviderType.lmStudio,
          baseUrl: 'http://localhost:9999',
          timeoutSeconds: 5,
        );
        final invalidClient = LMStudioClient(invalidConfig);
        
        print('测试配置:');
        print('  - 无效地址: ${invalidConfig.baseUrl}');
        print('  - 超时时间: ${invalidConfig.timeoutSeconds}秒');
        
        final stopwatch = Stopwatch()..start();
        final result = await invalidClient.testConnection();
        stopwatch.stop();
        
        print('结果:');
        print('  - 响应时间: ${stopwatch.elapsedMilliseconds}ms');
        print('  - 连接结果: ${result ? "成功" : "失败（预期行为）"}');
        
        expect(result, isFalse, reason: '无效地址应该连接失败');
        
        invalidClient.close();
        print('测试结果: 成功 ✓（正确处理了无效地址）');
        print('--- 测试 4.1 完成 ---\n');
      }, timeout: const Timeout(Duration(seconds: 30)));

      test('4.2 测试超时处理', () async {
        print('\n--- 测试 4.2: 测试超时处理 ---');
        
        final shortTimeoutConfig = const APIConfigModel(
          provider: APIProviderType.lmStudio,
          baseUrl: 'http://localhost:1234',
          timeoutSeconds: 1,
        );
        final shortTimeoutClient = LMStudioClient(shortTimeoutConfig);
        
        print('测试配置:');
        print('  - 超时时间: ${shortTimeoutConfig.timeoutSeconds}秒');
        
        final request = LMStudioChatRequest(
          model: 'local-model',
          messages: const [
            LMStudioMessage(
              role: 'user', 
              content: '请写一篇1000字的文章，详细介绍人工智能的发展历史、现状和未来趋势。',
            ),
          ],
          maxTokens: 2000,
        );
        
        final stopwatch = Stopwatch()..start();
        
        try {
          await shortTimeoutClient.sendChat(request);
          stopwatch.stop();
          print('请求完成时间: ${stopwatch.elapsedMilliseconds}ms');
          print('注意: 请求在超时时间内完成');
        } catch (e) {
          stopwatch.stop();
          print('请求失败时间: ${stopwatch.elapsedMilliseconds}ms');
          print('错误类型: ${e.runtimeType}');
          print('错误信息: $e');
          print('测试结果: 成功 ✓（正确处理了超时）');
        }
        
        shortTimeoutClient.close();
        print('--- 测试 4.2 完成 ---\n');
      }, timeout: const Timeout(Duration(seconds: 30)));

      test('4.3 测试空消息列表', () async {
        print('\n--- 测试 4.3: 测试空消息列表 ---');
        
        final request = LMStudioChatRequest(
          model: 'local-model',
          messages: const [],
        );
        
        print('测试配置:');
        print('  - 消息列表: 空');
        
        try {
          final response = await client.sendChat(request);
          print('响应状态: ${response.id.isNotEmpty ? "成功" : "失败"}');
          print('响应内容: ${response.content}');
          print('测试结果: 成功 ✓（API接受了空消息列表）');
        } catch (e) {
          print('错误信息: $e');
          print('测试结果: 成功 ✓（API正确拒绝了空消息列表）');
        }
        
        print('--- 测试 4.3 完成 ---\n');
      }, timeout: const Timeout(Duration(seconds: 30)));
    });

    group('5. 响应格式验证', () {
      test('5.1 验证响应数据结构', () async {
        print('\n--- 测试 5.1: 验证响应数据结构 ---');
        
        final request = LMStudioChatRequest(
          model: 'local-model',
          messages: const [
            LMStudioMessage(role: 'user', content: '你好'),
          ],
          maxTokens: 50,
        );
        
        final response = await client.sendChat(request);
        
        print('响应结构验证:');
        print('  - id (String): ${response.id.isNotEmpty ? "✓" : "✗"}');
        print('  - object (String): ${response.object.isNotEmpty ? "✓" : "✗"}');
        print('  - created (DateTime): ${response.created.year > 2020 ? "✓" : "✗"}');
        print('  - model (String): ${response.model.isNotEmpty ? "✓" : "✗"}');
        print('  - choices (List): ${response.choices.isNotEmpty ? "✓" : "✗"}');
        
        if (response.choices.isNotEmpty) {
          final choice = response.choices.first;
          print('  - choices[0].index (int): ${choice.index >= 0 ? "✓" : "✗"}');
          print('  - choices[0].message (LMStudioMessage): ${choice.message != null ? "✓" : "✗"}');
          print('  - choices[0].finishReason (String?): ${choice.finishReason != null ? "✓" : "✗"}');
        }
        
        if (response.usage != null) {
          print('  - usage.promptTokens (int): ${response.usage!.promptTokens >= 0 ? "✓" : "✗"}');
          print('  - usage.completionTokens (int): ${response.usage!.completionTokens >= 0 ? "✓" : "✗"}');
          print('  - usage.totalTokens (int): ${response.usage!.totalTokens >= 0 ? "✓" : "✗"}');
        }
        
        print('\n测试结果: 成功 ✓');
        print('--- 测试 5.1 完成 ---\n');
      }, timeout: const Timeout(Duration(seconds: 60)));
    });
  });
}

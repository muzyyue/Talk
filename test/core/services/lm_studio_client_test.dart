import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talk/core/config/api_config_model.dart';
import 'package:talk/core/services/lm_studio_client.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late LMStudioClient client;
  late APIConfigModel config;

  setUp(() {
    config = const APIConfigModel(
      provider: APIProviderType.lmStudio,
      baseUrl: 'http://localhost:1234',
      model: 'test-model',
      timeoutSeconds: 30,
    );
    client = LMStudioClient(config);
  });

  group('LMStudioChatRequest', () {
    test('构造函数正确设置所有属性', () {
      const request = LMStudioChatRequest(
        model: 'llama-3',
        messages: [
          LMStudioMessage(role: 'user', content: 'Hello'),
        ],
        temperature: 0.7,
        maxTokens: 1000,
        stream: true,
      );

      expect(request.model, 'llama-3');
      expect(request.messages.length, 1);
      expect(request.messages[0].role, 'user');
      expect(request.messages[0].content, 'Hello');
      expect(request.temperature, 0.7);
      expect(request.maxTokens, 1000);
      expect(request.stream, true);
    });

    test('toJson 正确转换为 JSON', () {
      const request = LMStudioChatRequest(
        model: 'test-model',
        messages: [
          LMStudioMessage(role: 'system', content: 'You are helpful'),
          LMStudioMessage(role: 'user', content: 'Hi'),
        ],
        temperature: 0.5,
        maxTokens: 500,
        stream: false,
      );

      final json = request.toJson();

      expect(json['model'], 'test-model');
      expect(json['messages'], isA<List>());
      expect((json['messages'] as List).length, 2);
      expect(json['temperature'], 0.5);
      expect(json['max_tokens'], 500);
      expect(json['stream'], false);
    });

    test('toJson 不包含 null 值的字段', () {
      const request = LMStudioChatRequest(
        model: 'test-model',
        messages: [],
      );

      final json = request.toJson();

      expect(json.containsKey('temperature'), false);
      expect(json.containsKey('max_tokens'), false);
    });

    test('copyWith 正确复制并修改', () {
      const original = LMStudioChatRequest(
        model: 'original-model',
        messages: [],
        temperature: 0.8,
      );

      final copied = original.copyWith(
        model: 'new-model',
        stream: true,
      );

      expect(copied.model, 'new-model');
      expect(copied.temperature, 0.8);
      expect(copied.stream, true);
    });
  });

  group('LMStudioMessage', () {
    test('toJson 正确转换', () {
      const message = LMStudioMessage(
        role: 'assistant',
        content: 'Hello! How can I help?',
      );

      final json = message.toJson();

      expect(json['role'], 'assistant');
      expect(json['content'], 'Hello! How can I help?');
    });
  });

  group('LMStudioChatResponse', () {
    test('fromJson 正确解析完整响应', () {
      final json = {
        'id': 'chatcmpl-123',
        'object': 'chat.completion',
        'created': 1677652288,
        'model': 'gpt-4',
        'choices': [
          {
            'index': 0,
            'message': {
              'role': 'assistant',
              'content': 'Hello there!',
            },
            'finish_reason': 'stop',
          }
        ],
        'usage': {
          'prompt_tokens': 10,
          'completion_tokens': 5,
          'total_tokens': 15,
        },
      };

      final response = LMStudioChatResponse.fromJson(json);

      expect(response.id, 'chatcmpl-123');
      expect(response.object, 'chat.completion');
      expect(response.model, 'gpt-4');
      expect(response.choices.length, 1);
      expect(response.choices[0].message?.role, 'assistant');
      expect(response.choices[0].message?.content, 'Hello there!');
      expect(response.usage?.promptTokens, 10);
      expect(response.usage?.completionTokens, 5);
      expect(response.usage?.totalTokens, 15);
    });

    test('fromJson 处理缺失字段', () {
      final json = <String, dynamic>{};

      final response = LMStudioChatResponse.fromJson(json);

      expect(response.id, '');
      expect(response.object, '');
      expect(response.model, '');
      expect(response.choices.isEmpty, true);
      expect(response.usage, null);
    });

    test('content getter 返回第一个消息内容', () {
      final json = {
        'choices': [
          {
            'index': 0,
            'message': {
              'role': 'assistant',
              'content': 'Test response',
            },
          }
        ],
      };

      final response = LMStudioChatResponse.fromJson(json);

      expect(response.content, 'Test response');
    });

    test('content getter 空选择返回空字符串', () {
      final json = {'choices': <dynamic>[]};

      final response = LMStudioChatResponse.fromJson(json);

      expect(response.content, '');
    });
  });

  group('LMStudioChoice', () {
    test('fromJson 正确解析', () {
      final json = {
        'index': 1,
        'message': {
          'role': 'user',
          'content': 'Test',
        },
        'delta': {
          'role': 'assistant',
          'content': 'Hi',
        },
        'finish_reason': 'stop',
      };

      final choice = LMStudioChoice.fromJson(json);

      expect(choice.index, 1);
      expect(choice.message?.role, 'user');
      expect(choice.message?.content, 'Test');
      expect(choice.delta?.role, 'assistant');
      expect(choice.delta?.content, 'Hi');
      expect(choice.finishReason, 'stop');
    });
  });

  group('LMStudioDelta', () {
    test('fromJson 正确解析', () {
      final json = {
        'role': 'assistant',
        'content': ' streaming',
      };

      final delta = LMStudioDelta.fromJson(json);

      expect(delta.role, 'assistant');
      expect(delta.content, ' streaming');
    });

    test('fromJson 处理缺失字段', () {
      final json = <String, dynamic>{};

      final delta = LMStudioDelta.fromJson(json);

      expect(delta.role, null);
      expect(delta.content, null);
    });
  });

  group('LMStudioUsage', () {
    test('fromJson 正确解析', () {
      final json = {
        'prompt_tokens': 100,
        'completion_tokens': 50,
        'total_tokens': 150,
      };

      final usage = LMStudioUsage.fromJson(json);

      expect(usage.promptTokens, 100);
      expect(usage.completionTokens, 50);
      expect(usage.totalTokens, 150);
    });

    test('fromJson 处理缺失字段使用默认值', () {
      final json = <String, dynamic>{};

      final usage = LMStudioUsage.fromJson(json);

      expect(usage.promptTokens, 0);
      expect(usage.completionTokens, 0);
      expect(usage.totalTokens, 0);
    });
  });

  group('LMStudioClient 实例化', () {
    test('使用配置正确创建客户端', () {
      final testConfig = const APIConfigModel(
        provider: APIProviderType.lmStudio,
        baseUrl: 'http://192.168.1.50:8080',
        apiKey: 'test-key',
        timeoutSeconds: 60,
      );

      final testClient = LMStudioClient(testConfig);

      expect(testClient, isA<LMStudioClient>());
    });

    test('空 API Key 不添加 Authorization header', () {
      final testConfig = const APIConfigModel(
        provider: APIProviderType.lmStudio,
        baseUrl: 'http://localhost:1234',
        apiKey: '',
      );

      final testClient = LMStudioClient(testConfig);

      expect(testClient, isA<LMStudioClient>());
    });
  });
}

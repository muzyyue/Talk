import 'package:flutter_test/flutter_test.dart';
import 'package:talk/core/config/api_config_model.dart';
import 'package:talk/core/services/ai_service.dart';

void main() {
  group('AIRequestModel', () {
    test('构造函数正确设置所有属性', () {
      const request = AIRequestModel(
        characterCardId: 'card-123',
        characterName: 'Test Character',
        personality: 'Friendly and helpful',
        scenario: 'Coffee shop',
        systemPrompt: 'Be helpful',
        userMessage: 'Hello!',
        temperature: 0.7,
        maxTokens: 1000,
      );

      expect(request.characterCardId, 'card-123');
      expect(request.characterName, 'Test Character');
      expect(request.personality, 'Friendly and helpful');
      expect(request.scenario, 'Coffee shop');
      expect(request.systemPrompt, 'Be helpful');
      expect(request.userMessage, 'Hello!');
      expect(request.temperature, 0.7);
      expect(request.maxTokens, 1000);
    });

    test('默认值正确设置', () {
      const request = AIRequestModel(
        characterCardId: 'card-1',
        characterName: 'Test',
        userMessage: 'Hi',
      );

      expect(request.personality, null);
      expect(request.scenario, null);
      expect(request.systemPrompt, null);
      expect(request.history, isEmpty);
      expect(request.temperature, 0.8);
      expect(request.maxTokens, 500);
    });
  });

  group('AIResponseModel', () {
    test('成功响应正确创建', () {
      const response = AIResponseModel(
        content: 'Hello! How can I help you?',
        emotion: 'happy',
        expression: 'smile',
        action: 'waves hand',
        success: true,
      );

      expect(response.content, 'Hello! How can I help you?');
      expect(response.emotion, 'happy');
      expect(response.expression, 'smile');
      expect(response.action, 'waves hand');
      expect(response.success, true);
      expect(response.error, null);
    });

    test('错误响应正确创建', () {
      const response = AIResponseModel(
        content: '',
        success: false,
        error: 'Connection timeout',
      );

      expect(response.content, '');
      expect(response.success, false);
      expect(response.error, 'Connection timeout');
    });

    test('默认 success 为 true', () {
      const response = AIResponseModel(content: 'Test');

      expect(response.success, true);
    });
  });

  group('AIServiceFactory', () {
    test('Mock 类型返回 MockAIService', () {
      const config = APIConfigModel(provider: APIProviderType.mock);
      final service = AIServiceFactory.create(config);

      expect(service, isA<MockAIService>());
    });

    test('LM Studio 类型返回 LMStudioAIService', () {
      const config = APIConfigModel(
        provider: APIProviderType.lmStudio,
        baseUrl: 'http://localhost:1234',
      );
      final service = AIServiceFactory.create(config);

      expect(service, isA<LMStudioAIService>());
    });

    test('OpenAI 类型返回 OpenAIService', () {
      const config = APIConfigModel(
        provider: APIProviderType.openAI,
        apiKey: 'test-key',
      );
      final service = AIServiceFactory.create(config);

      expect(service, isA<OpenAIService>());
    });

    test('Custom 类型返回 CustomAIService', () {
      const config = APIConfigModel(
        provider: APIProviderType.custom,
        baseUrl: 'http://custom.api:3000',
      );
      final service = AIServiceFactory.create(config);

      expect(service, isA<CustomAIService>());
    });
  });

  group('MockAIService', () {
    late MockAIService service;

    setUp(() {
      service = MockAIService();
    });

    test('sendMessage 返回模拟响应', () async {
      const request = AIRequestModel(
        characterCardId: 'test-id',
        characterName: 'TestBot',
        userMessage: 'Hello',
      );

      final response = await service.sendMessage(request);

      expect(response.success, true);
      expect(response.content, contains('TestBot'));
      expect(response.emotion, 'happy');
    });

    test('sendMessageStream 返回流式响应', () async {
      const request = AIRequestModel(
        characterCardId: 'test-id',
        characterName: 'Bot',
        userMessage: 'Hi',
      );

      final chunks = <String>[];
      await for (final response in service.sendMessageStream(request)) {
        if (response.success && response.content.isNotEmpty) {
          chunks.add(response.content);
        }
      }

      expect(chunks.isNotEmpty, true);
    });

    test('getAvailableModels 返回模拟模型列表', () async {
      final models = await service.getAvailableModels();

      expect(models, contains('mock-model'));
    });

    test('testConnection 返回 true', () async {
      final result = await service.testConnection();

      expect(result, true);
    });
  });

  group('OpenAIService', () {
    late OpenAIService service;

    setUp(() {
      service = OpenAIService(const APIConfigModel(provider: APIProviderType.openAI));
    });

    test('sendMessage 返回未实现错误', () async {
      const request = AIRequestModel(
        characterCardId: 'test',
        characterName: 'Test',
        userMessage: 'Hi',
      );

      final response = await service.sendMessage(request);

      expect(response.success, false);
      expect(response.error, contains('尚未实现'));
    });

    test('getAvailableModels 返回 GPT 模型列表', () async {
      final models = await service.getAvailableModels();

      expect(models, contains('gpt-3.5-turbo'));
      expect(models, contains('gpt-4'));
      expect(models, contains('gpt-4-turbo'));
    });

    test('testConnection 返回 false', () async {
      final result = await service.testConnection();

      expect(result, false);
    });
  });

  group('CustomAIService', () {
    late CustomAIService service;

    setUp(() {
      service = CustomAIService(const APIConfigModel(provider: APIProviderType.custom));
    });

    test('sendMessage 返回未实现错误', () async {
      const request = AIRequestModel(
        characterCardId: 'test',
        characterName: 'Test',
        userMessage: 'Hi',
      );

      final response = await service.sendMessage(request);

      expect(response.success, false);
      expect(response.error, contains('尚未实现'));
    });

    test('getAvailableModels 返回空列表', () async {
      final models = await service.getAvailableModels();

      expect(models, isEmpty);
    });

    test('testConnection 返回 false', () async {
      final result = await service.testConnection();

      expect(result, false);
    });
  });

  group('LMStudioAIService 系统提示词构建', () {
    test('系统提示词包含角色名称', () {
      final service = LMStudioAIService(const APIConfigModel(
        provider: APIProviderType.lmStudio,
        baseUrl: 'http://localhost:1234',
      ));

      const request = AIRequestModel(
        characterCardId: 'test',
        characterName: 'Alice',
        userMessage: 'Hi',
      );

      final messages = service.buildMessages(request);
      final systemMessage = messages.first;

      expect(systemMessage.role, 'system');
      expect(systemMessage.content, contains('Alice'));
      expect(systemMessage.content, contains('角色扮演'));
    });

    test('系统提示词包含性格特点', () {
      final service = LMStudioAIService(const APIConfigModel(
        provider: APIProviderType.lmStudio,
        baseUrl: 'http://localhost:1234',
      ));

      const request = AIRequestModel(
        characterCardId: 'test',
        characterName: 'Bot',
        personality: '友善、热情、乐于助人',
        userMessage: 'Hi',
      );

      final messages = service.buildMessages(request);
      final systemMessage = messages.first;

      expect(systemMessage.content, contains('友善、热情、乐于助人'));
      expect(systemMessage.content, contains('性格特点'));
    });

    test('系统提示词包含场景设定', () {
      final service = LMStudioAIService(const APIConfigModel(
        provider: APIProviderType.lmStudio,
        baseUrl: 'http://localhost:1234',
      ));

      const request = AIRequestModel(
        characterCardId: 'test',
        characterName: 'Bot',
        scenario: '一家温馨的咖啡厅',
        userMessage: 'Hi',
      );

      final messages = service.buildMessages(request);
      final systemMessage = messages.first;

      expect(systemMessage.content, contains('一家温馨的咖啡厅'));
      expect(systemMessage.content, contains('场景设定'));
    });

    test('消息列表包含用户消息', () {
      final service = LMStudioAIService(const APIConfigModel(
        provider: APIProviderType.lmStudio,
        baseUrl: 'http://localhost:1234',
      ));

      const request = AIRequestModel(
        characterCardId: 'test',
        characterName: 'Bot',
        userMessage: '你好，请问有什么可以帮助我的吗？',
      );

      final messages = service.buildMessages(request);

      expect(messages.last.role, 'user');
      expect(messages.last.content, '你好，请问有什么可以帮助我的吗？');
    });
  });
}

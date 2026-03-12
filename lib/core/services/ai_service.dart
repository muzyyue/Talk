import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/core/config/api_config_model.dart';
import 'package:talk/core/services/lm_studio_client.dart';
import 'package:talk/core/utils/logger.dart';
import 'package:talk/features/dialogue/data/models/chat_session_model.dart';

/// AI 服务接口
abstract class AIService {
  Future<AIResponseModel> sendMessage(AIRequestModel request);
  Stream<AIResponseModel> sendMessageStream(AIRequestModel request);
  Future<List<String>> getAvailableModels();
  Future<bool> testConnection();
}

/// AI 请求参数模型
class AIRequestModel {
  final String characterCardId;
  final String characterName;
  final String? personality;
  final String? scenario;
  final String? systemPrompt;
  final List<ChatMessageModel> history;
  final String userMessage;
  final double temperature;
  final int maxTokens;

  const AIRequestModel({
    required this.characterCardId,
    required this.characterName,
    this.personality,
    this.scenario,
    this.systemPrompt,
    this.history = const [],
    required this.userMessage,
    this.temperature = 0.8,
    this.maxTokens = 500,
  });
}

/// AI 响应模型
class AIResponseModel {
  final String content;
  final String? emotion;
  final String? expression;
  final String? action;
  final bool success;
  final String? error;

  const AIResponseModel({
    required this.content,
    this.emotion,
    this.expression,
    this.action,
    this.success = true,
    this.error,
  });
}

/// AI 服务工厂
/// 
/// 根据配置创建对应的 AI 服务实例
class AIServiceFactory {
  static AIService create(APIConfigModel config) {
    switch (config.provider) {
      case APIProviderType.lmStudio:
        return LMStudioAIService(config);
      case APIProviderType.openAI:
        return OpenAIService(config);
      case APIProviderType.custom:
        return CustomAIService(config);
      case APIProviderType.mock:
      default:
        return MockAIService();
    }
  }
}

/// LM Studio AI 服务实现
class LMStudioAIService implements AIService {
  final LMStudioClient _client;
  final APIConfigModel _config;

  LMStudioAIService(this._config) : _client = LMStudioClient(_config);

  @override
  Future<AIResponseModel> sendMessage(AIRequestModel request) async {
    try {
      final messages = buildMessages(request);
      
      final chatRequest = LMStudioChatRequest(
        model: _config.model.isNotEmpty ? _config.model : 'local-model',
        messages: messages,
        temperature: request.temperature,
        maxTokens: request.maxTokens,
        stream: false,
      );

      final response = await _client.sendChat(chatRequest);
      
      return AIResponseModel(
        content: response.content,
        success: true,
      );
    } catch (e) {
      AppLogger.error('LM Studio request failed: $e');
      return AIResponseModel(
        content: '',
        success: false,
        error: e.toString(),
      );
    }
  }

  @override
  Stream<AIResponseModel> sendMessageStream(AIRequestModel request) async* {
    try {
      final messages = buildMessages(request);
      
      final chatRequest = LMStudioChatRequest(
        model: _config.model.isNotEmpty ? _config.model : 'local-model',
        messages: messages,
        temperature: request.temperature,
        maxTokens: request.maxTokens,
        stream: true,
      );

      await for (final response in _client.sendChatStream(chatRequest)) {
        final delta = response.choices.isNotEmpty 
            ? response.choices.first.delta?.content 
            : null;
        
        if (delta != null && delta.isNotEmpty) {
          yield AIResponseModel(
            content: delta,
            success: true,
          );
        }
      }
    } catch (e) {
      AppLogger.error('LM Studio stream request failed: $e');
      yield AIResponseModel(
        content: '',
        success: false,
        error: e.toString(),
      );
    }
  }

  @override
  Future<List<String>> getAvailableModels() async {
    try {
      final models = await _client.getModels();
      return models.map((m) => m.id).toList();
    } catch (e) {
      AppLogger.error('Failed to get models: $e');
      return [];
    }
  }

  @override
  Future<bool> testConnection() async {
    return await _client.testConnection();
  }

  /// 构建消息列表
  List<LMStudioMessage> buildMessages(AIRequestModel request) {
    final messages = <LMStudioMessage>[];

    final systemPrompt = _buildSystemPrompt(request);
    messages.add(LMStudioMessage(role: 'system', content: systemPrompt));

    for (final msg in request.history) {
      final role = msg.role == MessageRole.user ? 'user' : 'assistant';
      messages.add(LMStudioMessage(role: role, content: msg.content));
    }

    messages.add(LMStudioMessage(role: 'user', content: request.userMessage));

    return messages;
  }

  /// 构建系统提示词
  String _buildSystemPrompt(AIRequestModel request) {
    final buffer = StringBuffer();

    buffer.writeln('你是一个角色扮演AI，需要扮演以下角色：');
    buffer.writeln('');
    buffer.writeln('角色名称：${request.characterName}');
    
    if (request.personality != null && request.personality!.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('性格特点：');
      buffer.writeln(request.personality!);
    }

    if (request.scenario != null && request.scenario!.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('场景设定：');
      buffer.writeln(request.scenario!);
    }

    if (request.systemPrompt != null && request.systemPrompt!.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('额外指令：');
      buffer.writeln(request.systemPrompt!);
    }

    buffer.writeln('');
    buffer.writeln('请始终保持角色特征，用角色的语气和风格回复用户。不要跳出角色，不要提及你是AI。');

    return buffer.toString();
  }
}

/// OpenAI 服务实现
class OpenAIService implements AIService {
  final APIConfigModel _config;

  OpenAIService(this._config);

  @override
  Future<AIResponseModel> sendMessage(AIRequestModel request) async {
    return AIResponseModel(
      content: 'OpenAI 服务尚未实现',
      success: false,
      error: 'OpenAI 服务尚未实现',
    );
  }

  @override
  Stream<AIResponseModel> sendMessageStream(AIRequestModel request) async* {
    yield AIResponseModel(
      content: '',
      success: false,
      error: 'OpenAI 服务尚未实现',
    );
  }

  @override
  Future<List<String>> getAvailableModels() async {
    return ['gpt-3.5-turbo', 'gpt-4', 'gpt-4-turbo'];
  }

  @override
  Future<bool> testConnection() async {
    return false;
  }
}

/// 自定义 API 服务实现
class CustomAIService implements AIService {
  final APIConfigModel _config;

  CustomAIService(this._config);

  @override
  Future<AIResponseModel> sendMessage(AIRequestModel request) async {
    return AIResponseModel(
      content: '自定义服务尚未实现',
      success: false,
      error: '自定义服务尚未实现',
    );
  }

  @override
  Stream<AIResponseModel> sendMessageStream(AIRequestModel request) async* {
    yield AIResponseModel(
      content: '',
      success: false,
      error: '自定义服务尚未实现',
    );
  }

  @override
  Future<List<String>> getAvailableModels() async {
    return [];
  }

  @override
  Future<bool> testConnection() async {
    return false;
  }
}

/// Mock AI 服务（用于测试）
class MockAIService implements AIService {
  @override
  Future<AIResponseModel> sendMessage(AIRequestModel request) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return AIResponseModel(
      content: '你好！我是${request.characterName}。很高兴认识你！这是一个模拟的回复。',
      emotion: 'happy',
      success: true,
    );
  }

  @override
  Stream<AIResponseModel> sendMessageStream(AIRequestModel request) async* {
    final responses = [
      '你',
      '好',
      '！',
      '我',
      '是',
      ' ${request.characterName}',
      '。',
    ];

    for (final char in responses) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield AIResponseModel(
        content: char,
        success: true,
      );
    }
  }

  @override
  Future<List<String>> getAvailableModels() async {
    return ['mock-model'];
  }

  @override
  Future<bool> testConnection() async {
    return true;
  }
}

/// AI 服务 Provider
final aiServiceProvider = Provider<AIService>((ref) {
  final config = ref.watch(apiConfigProvider);
  return AIServiceFactory.create(config);
});

/// API 配置 Provider
final apiConfigProvider = StateProvider<APIConfigModel>((ref) {
  return const APIConfigModel();
});

/// 可用模型列表 Provider
final availableModelsProvider = FutureProvider<List<String>>((ref) async {
  final aiService = ref.watch(aiServiceProvider);
  return await aiService.getAvailableModels();
});

/// API 连接状态 Provider
final apiConnectionStatusProvider = StateProvider<bool>((ref) => false);

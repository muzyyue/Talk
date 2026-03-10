import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/core/network/api_client.dart';
import 'package:talk/core/utils/logger.dart';
import '../models/chat_session_model.dart';

/// AI 服务接口
abstract class AIService {
  Future<AIResponseModel> sendMessage(AIRequestModel request);
  Stream<AIResponseModel> sendMessageStream(AIRequestModel request);
}

/// AI 服务实现
class AIServiceImpl implements AIService {
  final ApiClient _apiClient;

  AIServiceImpl(this._apiClient);

  @override
  Future<AIResponseModel> sendMessage(AIRequestModel request) async {
    try {
      final messages = _buildMessages(request);
      
      final response = await _apiClient.post(
        '/chat/completions',
        data: {
          'model': 'gpt-3.5-turbo',
          'messages': messages,
          'temperature': request.temperature,
          'max_tokens': request.maxTokens,
        },
      );

      final content = response.data['choices'][0]['message']['content'] as String;
      
      return AIResponseModel(
        content: content,
        success: true,
      );
    } catch (e) {
      AppLogger.error('AI request failed: $e');
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
      yield AIResponseModel(
        content: '',
        success: true,
      );

      for (int i = 0; i < 3; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        yield AIResponseModel(
          content: '正在思考中...',
          success: true,
        );
      }

      yield AIResponseModel(
        content: '这是一个模拟的AI回复。在实际应用中，这里会调用真实的AI API。',
        success: true,
      );
    } catch (e) {
      AppLogger.error('AI stream request failed: $e');
      yield AIResponseModel(
        content: '',
        success: false,
        error: e.toString(),
      );
    }
  }

  /// 构建消息列表
  List<Map<String, String>> _buildMessages(AIRequestModel request) {
    final messages = <Map<String, String>>[];

    final systemPrompt = _buildSystemPrompt(request);
    messages.add({'role': 'system', 'content': systemPrompt});

    for (final msg in request.history) {
      final role = msg.role == MessageRole.user ? 'user' : 'assistant';
      messages.add({'role': role, 'content': msg.content});
    }

    messages.add({'role': 'user', 'content': request.userMessage});

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

/// AI 服务 Provider
final aiServiceProvider = Provider<AIService>((ref) {
  return AIServiceImpl(ApiClient.instance);
});

/// 模拟 AI 服务（用于测试）
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
}

/// 模拟 AI 服务 Provider
final mockAIServiceProvider = Provider<AIService>((ref) {
  return MockAIService();
});

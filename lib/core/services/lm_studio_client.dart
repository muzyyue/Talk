import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/core/config/api_config_model.dart';
import 'package:talk/core/utils/logger.dart';
import 'ai_service.dart';

/// LM Studio API 客户端
/// 
/// 负责与 LM Studio 本地服务进行通信
/// 兼容 OpenAI API 格式
class LMStudioClient {
  final Dio _dio;
  final APIConfigModel _config;

  LMStudioClient(this._config)
      : _dio = Dio(BaseOptions(
          baseUrl: _config.baseUrl,
          connectTimeout: Duration(seconds: _config.timeoutSeconds),
          receiveTimeout: Duration(seconds: _config.timeoutSeconds * 2),
          headers: {
            'Content-Type': 'application/json',
            if (_config.apiKey.isNotEmpty) 'Authorization': 'Bearer ${_config.apiKey}',
          },
        ));

  /// 获取可用模型列表
  Future<List<LMStudioModel>> getModels() async {
    try {
      final response = await _dio.get('/v1/models');
      final modelsResponse = LMStudioModelsResponse.fromJson(response.data);
      AppLogger.debug('Available models: ${modelsResponse.data.map((m) => m.id).join(', ')}');
      return modelsResponse.data;
    } on DioException catch (e) {
      AppLogger.error('Failed to get models: ${e.message}');
      rethrow;
    }
  }

  /// 发送聊天请求（非流式）
  Future<LMStudioChatResponse> sendChat(LMStudioChatRequest request) async {
    try {
      final response = await _dio.post(
        '/v1/chat/completions',
        data: request.toJson(),
      );
      
      return LMStudioChatResponse.fromJson(response.data);
    } on DioException catch (e) {
      AppLogger.error('Chat request failed: ${e.message}');
      rethrow;
    }
  }

  /// 发送聊天请求（流式）
  Stream<LMStudioChatResponse> sendChatStream(LMStudioChatRequest request) async* {
    try {
      final streamRequest = request.copyWith(stream: true);
      final response = await _dio.post(
        '/v1/chat/completions',
        data: streamRequest.toJson(),
        options: Options(
          responseType: ResponseType.stream,
        ),
      );

      final stream = response.data.stream as Stream<List<int>>;
      await for (final chunk in stream) {
        final text = utf8.decode(chunk);
        final lines = text.split('\n').where((line) => line.trim().isNotEmpty);
        
        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6);
            if (data == '[DONE]') {
              break;
            }
            try {
              final json = jsonDecode(data) as Map<String, dynamic>;
              yield LMStudioChatResponse.fromJson(json);
            } catch (e) {
              // 忽略解析错误
            }
          }
        }
      }
    } on DioException catch (e) {
      AppLogger.error('Stream chat request failed: ${e.message}');
      rethrow;
    }
  }

  /// 测试连接
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/v1/models');
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.error('Connection test failed: $e');
      return false;
    }
  }

  /// 关闭客户端
  void close() {
    _dio.close();
  }
}

/// LM Studio 聊天请求
class LMStudioChatRequest {
  final String model;
  final List<LMStudioMessage> messages;
  final double? temperature;
  final int? maxTokens;
  final bool stream;

  const LMStudioChatRequest({
    required this.model,
    required this.messages,
    this.temperature,
    this.maxTokens,
    this.stream = false,
  });

  LMStudioChatRequest copyWith({
    String? model,
    List<LMStudioMessage>? messages,
    double? temperature,
    int? maxTokens,
    bool? stream,
  }) {
    return LMStudioChatRequest(
      model: model ?? this.model,
      messages: messages ?? this.messages,
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
      stream: stream ?? this.stream,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'messages': messages.map((m) => m.toJson()).toList(),
      if (temperature != null) 'temperature': temperature,
      if (maxTokens != null) 'max_tokens': maxTokens,
      'stream': stream,
    };
  }
}

/// LM Studio 消息
class LMStudioMessage {
  final String role;
  final String content;

  const LMStudioMessage({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}

/// LM Studio 聊天响应
class LMStudioChatResponse {
  final String id;
  final String object;
  final DateTime created;
  final String model;
  final List<LMStudioChoice> choices;
  final LMStudioUsage? usage;

  const LMStudioChatResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    this.usage,
  });

  factory LMStudioChatResponse.fromJson(Map<String, dynamic> json) {
    return LMStudioChatResponse(
      id: json['id'] as String? ?? '',
      object: json['object'] as String? ?? '',
      created: DateTime.fromMillisecondsSinceEpoch(
        (json['created'] as int? ?? 0) * 1000,
      ),
      model: json['model'] as String? ?? '',
      choices: (json['choices'] as List?)
          ?.map((e) => LMStudioChoice.fromJson(e))
          .toList() ?? [],
      usage: json['usage'] != null
          ? LMStudioUsage.fromJson(json['usage'])
          : null,
    );
  }

  /// 获取响应文本
  String get content => choices.isNotEmpty ? choices.first.message?.content ?? '' : '';
}

/// LM Studio 选择项
class LMStudioChoice {
  final int index;
  final LMStudioMessage? message;
  final LMStudioDelta? delta;
  final String? finishReason;

  const LMStudioChoice({
    required this.index,
    this.message,
    this.delta,
    this.finishReason,
  });

  factory LMStudioChoice.fromJson(Map<String, dynamic> json) {
    return LMStudioChoice(
      index: json['index'] as int? ?? 0,
      message: json['message'] != null
          ? LMStudioMessage(
              role: json['message']['role'] as String? ?? '',
              content: json['message']['content'] as String? ?? '',
            )
          : null,
      delta: json['delta'] != null
          ? LMStudioDelta.fromJson(json['delta'])
          : null,
      finishReason: json['finish_reason'] as String?,
    );
  }
}

/// LM Studio 增量消息（流式响应）
class LMStudioDelta {
  final String? role;
  final String? content;

  const LMStudioDelta({this.role, this.content});

  factory LMStudioDelta.fromJson(Map<String, dynamic> json) {
    return LMStudioDelta(
      role: json['role'] as String?,
      content: json['content'] as String?,
    );
  }
}

/// LM Studio 使用量
class LMStudioUsage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  const LMStudioUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory LMStudioUsage.fromJson(Map<String, dynamic> json) {
    return LMStudioUsage(
      promptTokens: json['prompt_tokens'] as int? ?? 0,
      completionTokens: json['completion_tokens'] as int? ?? 0,
      totalTokens: json['total_tokens'] as int? ?? 0,
    );
  }
}

/// LM Studio 客户端 Provider
final lmStudioClientProvider = Provider<LMStudioClient>((ref) {
  final config = ref.watch(apiConfigProvider);
  return LMStudioClient(config);
});

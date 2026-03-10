import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_session_model.freezed.dart';
part 'chat_session_model.g.dart';

/// 对话会话模型
@freezed
class ChatSessionModel with _$ChatSessionModel {
  const factory ChatSessionModel({
    required String id,
    required String characterCardId,
    @Default([]) List<ChatMessageModel> messages,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ChatSessionModel;

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionModelFromJson(json);
}

/// 对话消息模型
@freezed
class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    required String id,
    required MessageRole role,
    required String content,
    required DateTime timestamp,
    MessageMetadataModel? metadata,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);
}

/// 消息角色
enum MessageRole {
  user,
  character,
  system,
}

/// 消息元数据
@freezed
class MessageMetadataModel with _$MessageMetadataModel {
  const factory MessageMetadataModel({
    String? emotion,
    String? expression,
    String? action,
  }) = _MessageMetadataModel;

  factory MessageMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$MessageMetadataModelFromJson(json);
}

/// 对话上下文模型
/// 
/// 用于 AI 理解对话状态
class ChatContextModel {
  final int totalMessages;
  final int affectionLevel;
  final List<String> topics;
  final List<String> memories;
  final String? lastTopic;

  const ChatContextModel({
    this.totalMessages = 0,
    this.affectionLevel = 0,
    this.topics = const [],
    this.memories = const [],
    this.lastTopic,
  });

  ChatContextModel copyWith({
    int? totalMessages,
    int? affectionLevel,
    List<String>? topics,
    List<String>? memories,
    String? lastTopic,
  }) {
    return ChatContextModel(
      totalMessages: totalMessages ?? this.totalMessages,
      affectionLevel: affectionLevel ?? this.affectionLevel,
      topics: topics ?? this.topics,
      memories: memories ?? this.memories,
      lastTopic: lastTopic ?? this.lastTopic,
    );
  }
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

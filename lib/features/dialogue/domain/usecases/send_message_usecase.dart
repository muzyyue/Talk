import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/features/dialogue/domain/entities/chat_session.dart';

/// 发送消息用例
class SendMessageUseCase {
  Future<ChatMessage> call(SendMessageParams params) async {
    return ChatMessage(
      id: params.messageId,
      role: MessageRole.user,
      content: params.content,
      timestamp: DateTime.now(),
    );
  }
}

/// 发送消息参数
class SendMessageParams {
  final String sessionId;
  final String messageId;
  final String content;

  const SendMessageParams({
    required this.sessionId,
    required this.messageId,
    required this.content,
  });
}

/// 发送消息用例 Provider
final sendMessageUseCaseProvider = Provider<SendMessageUseCase>(
  (ref) => SendMessageUseCase(),
);

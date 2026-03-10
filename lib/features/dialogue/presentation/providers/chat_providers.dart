import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:talk/features/dialogue/data/models/chat_session_model.dart';
import 'package:talk/features/dialogue/data/repositories/chat_repository.dart';
import 'package:talk/features/dialogue/data/services/ai_service.dart';
import 'package:talk/features/character_card/domain/entities/character_card.dart';
import 'package:talk/features/character_card/domain/usecases/get_character_cards_usecase.dart';

/// 对话状态
class ChatState {
  final ChatSessionModel? session;
  final CharacterCard? character;
  final bool isLoading;
  final bool isTyping;
  final String? error;

  const ChatState({
    this.session,
    this.character,
    this.isLoading = false,
    this.isTyping = false,
    this.error,
  });

  ChatState copyWith({
    ChatSessionModel? session,
    CharacterCard? character,
    bool? isLoading,
    bool? isTyping,
    String? error,
  }) {
    return ChatState(
      session: session ?? this.session,
      character: character ?? this.character,
      isLoading: isLoading ?? this.isLoading,
      isTyping: isTyping ?? this.isTyping,
      error: error,
    );
  }
}

/// 对话状态管理
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _chatRepository;
  final AIService _aiService;
  final GetCharacterCardDetailUseCase _getCharacterDetail;
  static const _uuid = Uuid();

  ChatNotifier(
    this._chatRepository,
    this._aiService,
    this._getCharacterDetail,
  ) : super(const ChatState());

  /// 初始化对话
  Future<void> init(String characterCardId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final character = await _getCharacterDetail(characterCardId);
      if (character == null) {
        state = state.copyWith(
          isLoading: false,
          error: '角色卡不存在',
        );
        return;
      }

      final sessions = await _chatRepository.getSessionsByCharacterId(characterCardId);
      ChatSessionModel session;
      
      if (sessions.isEmpty) {
        session = await _chatRepository.createSession(characterCardId);
      } else {
        session = sessions.first;
      }

      state = state.copyWith(
        session: session,
        character: character,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 发送消息
  Future<void> sendMessage(String content) async {
    final session = state.session;
    final character = state.character;
    
    if (session == null || character == null) return;

    final userMessage = ChatMessageModel(
      id: _uuid.v4(),
      role: MessageRole.user,
      content: content,
      timestamp: DateTime.now(),
    );

    final updatedSession = await _chatRepository.addMessage(session.id, userMessage);
    state = state.copyWith(session: updatedSession, isTyping: true);

    try {
      final aiRequest = AIRequestModel(
        characterCardId: character.id,
        characterName: character.name,
        personality: character.personality,
        scenario: character.scenario,
        systemPrompt: character.systemPrompt,
        history: updatedSession.messages,
        userMessage: content,
      );

      final aiResponse = await _aiService.sendMessage(aiRequest);
      
      if (aiResponse.success) {
        final characterMessage = ChatMessageModel(
          id: _uuid.v4(),
          role: MessageRole.character,
          content: aiResponse.content,
          timestamp: DateTime.now(),
          metadata: MessageMetadataModel(
            emotion: aiResponse.emotion,
            expression: aiResponse.expression,
            action: aiResponse.action,
          ),
        );

        final finalSession = await _chatRepository.addMessage(updatedSession.id, characterMessage);
        state = state.copyWith(
          session: finalSession,
          isTyping: false,
        );
      } else {
        state = state.copyWith(
          isTyping: false,
          error: aiResponse.error ?? 'AI 响应失败',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: e.toString(),
      );
    }
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// 对话 Provider
final chatProvider = StateNotifierProvider.family<ChatNotifier, ChatState, String>(
  (ref, characterCardId) => ChatNotifier(
    ref.watch(chatRepositoryProvider),
    ref.watch(mockAIServiceProvider),
    ref.watch(getCharacterCardDetailUseCaseProvider),
  ),
);

/// 对话历史列表 Provider
final chatHistoryProvider = FutureProvider<List<ChatSessionModel>>((ref) async {
  final repository = ref.watch(chatRepositoryProvider);
  return await repository.getAllSessions();
});

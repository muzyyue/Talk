import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:talk/core/constants/storage_keys.dart';
import 'package:talk/core/utils/logger.dart';
import 'package:talk/features/dialogue/data/models/chat_session_model.dart';
import 'package:talk/features/dialogue/data/models/chat_session_adapter.dart';

/// 对话仓库
abstract class ChatRepository {
  Future<List<ChatSessionModel>> getAllSessions();
  Future<ChatSessionModel?> getSessionById(String id);
  Future<List<ChatSessionModel>> getSessionsByCharacterId(String characterId);
  Future<ChatSessionModel> createSession(String characterCardId);
  Future<ChatSessionModel> saveSession(ChatSessionModel session);
  Future<void> deleteSession(String id);
  Future<ChatSessionModel> addMessage(String sessionId, ChatMessageModel message);
}

/// 对话仓库实现
class ChatRepositoryImpl implements ChatRepository {
  static const _uuid = Uuid();
  static Box<ChatSessionModel>? _box;
  static bool _initialized = false;

  ChatRepositoryImpl();

  /// 初始化仓库
  Future<void> init() async {
    if (_initialized) return;

    // 注册 Hive 适配器（忽略重复注册的错误）
    try {
      Hive.registerAdapter(ChatSessionModelAdapter());
    } catch (_) {}
    try {
      Hive.registerAdapter(ChatMessageModelAdapter());
    } catch (_) {}
    try {
      Hive.registerAdapter(MessageRoleAdapter());
    } catch (_) {}
    try {
      Hive.registerAdapter(MessageMetadataModelAdapter());
    } catch (_) {}
    
    _box = await Hive.openBox<ChatSessionModel>(StorageKeys.chatSessionsBox);
    _initialized = true;
    AppLogger.debug('ChatRepository initialized');
  }

  /// 获取 Box 实例
  Box<ChatSessionModel> get box {
    if (_box == null) {
      throw StateError('ChatRepository not initialized. Call init() first.');
    }
    return _box!;
  }

  /// 获取所有对话会话
  @override
  Future<List<ChatSessionModel>> getAllSessions() async {
    final sessions = box.values.toList();
    sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sessions;
  }

  /// 根据ID获取会话
  @override
  Future<ChatSessionModel?> getSessionById(String id) async {
    try {
      return box.values.firstWhere((session) => session.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 根据角色卡ID获取会话列表
  @override
  Future<List<ChatSessionModel>> getSessionsByCharacterId(String characterId) async {
    final sessions = box.values
        .where((session) => session.characterCardId == characterId)
        .toList();
    sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sessions;
  }

  /// 创建新会话
  @override
  Future<ChatSessionModel> createSession(String characterCardId) async {
    final now = DateTime.now();
    final session = ChatSessionModel(
      id: _uuid.v4(),
      characterCardId: characterCardId,
      messages: [],
      createdAt: now,
      updatedAt: now,
    );

    await box.put(session.id, session);
    AppLogger.debug('Created chat session: ${session.id}');
    return session;
  }

  /// 保存会话
  @override
  Future<ChatSessionModel> saveSession(ChatSessionModel session) async {
    final updatedSession = session.copyWith(updatedAt: DateTime.now());
    await box.put(updatedSession.id, updatedSession);
    AppLogger.debug('Saved chat session: ${updatedSession.id}');
    return updatedSession;
  }

  /// 删除会话
  @override
  Future<void> deleteSession(String id) async {
    await box.delete(id);
    AppLogger.debug('Deleted chat session: $id');
  }

  /// 添加消息到会话
  @override
  Future<ChatSessionModel> addMessage(String sessionId, ChatMessageModel message) async {
    final session = await getSessionById(sessionId);
    if (session == null) {
      throw StateError('Session not found: $sessionId');
    }

    final updatedSession = session.copyWith(
      messages: [...session.messages, message],
      updatedAt: DateTime.now(),
    );

    await box.put(updatedSession.id, updatedSession);
    return updatedSession;
  }
}

/// 对话仓库 Provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});

/// 对话仓库初始化 Provider
final chatRepositoryInitProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(chatRepositoryProvider) as ChatRepositoryImpl;
  await repository.init();
});

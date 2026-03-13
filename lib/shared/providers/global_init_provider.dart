import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/features/character_card/data/repositories/character_card_repository.dart';
import 'package:talk/features/dialogue/data/repositories/chat_repository.dart';

/// 全局初始化 Provider
/// 
/// 在应用启动时初始化基础设施
final globalInitProvider = FutureProvider<void>((ref) async {
  // 初始化角色卡仓库（会自动添加默认角色卡）
  final characterCardRepo = ref.watch(characterCardRepositoryProvider) as CharacterCardRepositoryImpl;
  await characterCardRepo.init();
  
  // 初始化对话仓库
  final chatRepo = ref.watch(chatRepositoryProvider) as ChatRepositoryImpl;
  await chatRepo.init();
});

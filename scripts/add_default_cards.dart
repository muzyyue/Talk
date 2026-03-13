import 'dart:io';
import 'package:hive/hive.dart';
import 'package:talk/core/constants/storage_keys.dart';
import 'package:talk/features/character_card/data/models/character_card_model.dart';
import 'package:talk/features/character_card/data/models/character_card_adapter.dart';
import 'package:talk/features/character_card/data/services/default_character_cards.dart';

/// 手动添加默认角色卡脚本
/// 
/// 用于在应用首次启动后手动添加默认角色卡
void main() async {
  print('🚀 开始添加默认角色卡...');

  // 初始化 Hive
  Hive.init('C:/Users/Administrator/AppData/Local/talk');

  // 注册适配器
  Hive.registerAdapter(CharacterCardModelAdapter());
  Hive.registerAdapter(CharacterCardDataModelAdapter());
  Hive.registerAdapter(CharacterExtensionsModelAdapter());
  Hive.registerAdapter(CharacterProfileModelAdapter());
  Hive.registerAdapter(CharacterCardSourceAdapter());

  // 打开角色卡盒子
  final box = await Hive.openBox<CharacterCardModel>(StorageKeys.characterCardsBox);

  print('📦 当前角色卡数量：${box.values.length}');

  // 检查是否已有默认角色卡
  final hasDefaultCard = box.values.any(
    (card) => DefaultCharacterCards.isDefaultCard(card),
  );

  if (hasDefaultCard) {
    print('✅ 默认角色卡已存在，跳过添加');
  } else {
    print('➕ 正在添加默认角色卡...');
    final defaultCards = DefaultCharacterCards.getDefaultCards();

    for (final card in defaultCards) {
      await box.put(card.id, card);
      print('✓ 已添加：${card.data.name} (${card.data.extensions?.nickname})');
    }

    print('✅ 添加完成！当前角色卡数量：${box.values.length}');
  }

  // 显示所有角色卡
  print('\n📋 角色卡列表:');
  for (final card in box.values) {
    print('  - ${card.data.name} [${card.data.tags.join(", ")}]');
  }

  // 关闭盒子
  await box.close();

  print('\n✨ 完成！请重启应用查看角色卡');
  exit(0);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:talk/core/constants/storage_keys.dart';
import 'package:talk/core/utils/logger.dart';
import 'package:talk/features/character_card/data/models/character_card_model.dart';
import 'package:talk/features/character_card/data/models/character_card_adapter.dart';
import 'package:talk/features/character_card/data/services/default_character_cards.dart';

/// 角色卡仓库
/// 
/// 提供角色卡的增删改查操作
abstract class CharacterCardRepository {
  Future<List<CharacterCardModel>> getAll();
  Future<CharacterCardModel?> getById(String id);
  Future<CharacterCardModel> save(CharacterCardModel card);
  Future<void> delete(String id);
  Future<CharacterCardModel> importFromJson(Map<String, dynamic> json);
  Map<String, dynamic> exportToJson(CharacterCardModel card);
}

/// 角色卡仓库实现
/// 
/// 基于 Hive 的角色卡存储实现
class CharacterCardRepositoryImpl implements CharacterCardRepository {
  static const _uuid = Uuid();
  static Box<CharacterCardModel>? _box;
  static bool _initialized = false;

  CharacterCardRepositoryImpl();

  /// 初始化仓库
  Future<void> init() async {
    if (_initialized) return;
    
    Hive.registerAdapter(CharacterCardModelAdapter());
    Hive.registerAdapter(CharacterCardDataModelAdapter());
    Hive.registerAdapter(CharacterExtensionsModelAdapter());
    Hive.registerAdapter(CharacterProfileModelAdapter());
    Hive.registerAdapter(CharacterCardSourceAdapter());
    _box = await Hive.openBox<CharacterCardModel>(StorageKeys.characterCardsBox);
    
    await _initializeDefaultCards();
    
    _initialized = true;
    AppLogger.debug('CharacterCardRepository initialized');
  }

  /// 初始化默认角色卡
  ///
  /// 检查并添加默认角色卡，避免重复添加
  Future<void> _initializeDefaultCards() async {
    final existingCards = box.values.toList();
    final hasDefaultCard = existingCards.any(
      (card) => DefaultCharacterCards.isDefaultCard(card),
    );

    if (!hasDefaultCard) {
      final defaultCards = DefaultCharacterCards.getDefaultCards();
      for (final card in defaultCards) {
        await box.put(card.id, card);
        AppLogger.debug('Added default character card: ${card.data.name}');
      }
    }
  }

  /// 获取 Box 实例
  Box<CharacterCardModel> get box {
    if (_box == null) {
      throw StateError('CharacterCardRepository not initialized. Call init() first.');
    }
    return _box!;
  }

  /// 获取所有角色卡
  /// 
  /// 按更新时间倒序排列
  @override
  Future<List<CharacterCardModel>> getAll() async {
    final cards = box.values.toList();
    cards.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return cards;
  }

  /// 根据ID获取角色卡
  @override
  Future<CharacterCardModel?> getById(String id) async {
    try {
      return box.values.firstWhere(
        (card) => card.id == id,
      );
    } catch (e) {
      return null;
    }
  }

  /// 保存角色卡
  /// 
  /// 如果是新建角色卡，会自动生成ID
  @override
  Future<CharacterCardModel> save(CharacterCardModel card) async {
    final now = DateTime.now();
    CharacterCardModel savedCard;

    if (card.id.isEmpty) {
      savedCard = card.copyWith(
        id: _uuid.v4(),
        createdAt: now,
        updatedAt: now,
      );
    } else {
      savedCard = card.copyWith(updatedAt: now);
    }

    await box.put(savedCard.id, savedCard);
    AppLogger.debug('Saved character card: ${savedCard.id}');
    return savedCard;
  }

  /// 删除角色卡
  @override
  Future<void> delete(String id) async {
    await box.delete(id);
    AppLogger.debug('Deleted character card: $id');
  }

  /// 从JSON导入角色卡
  /// 
  /// 支持 chara_card_v2 格式
  @override
  Future<CharacterCardModel> importFromJson(Map<String, dynamic> json) async {
    final spec = json['spec'] as String? ?? 'chara_card_v2';
    final specVersion = json['spec_version'] as String? ?? '2.0';
    final dataJson = json['data'] as Map<String, dynamic>? ?? json;

    final data = CharacterCardDataModel(
      name: dataJson['name'] as String? ?? '未命名角色',
      description: dataJson['description'] as String?,
      personality: dataJson['personality'] as String?,
      scenario: dataJson['scenario'] as String?,
      firstMes: dataJson['first_mes'] as String? ?? dataJson['firstMes'] as String?,
      mesExample: dataJson['mes_example'] as String? ?? dataJson['mesExample'] as String?,
      creatorNotes: dataJson['creator_notes'] as String? ?? dataJson['creatorNotes'] as String?,
      systemPrompt: dataJson['system_prompt'] as String? ?? dataJson['systemPrompt'] as String?,
      postHistoryInstructions: dataJson['post_history_instructions'] as String?,
      alternateGreetings: dataJson['alternate_greetings'] as String?,
      tags: (dataJson['tags'] as List?)?.cast<String>() ?? [],
      creator: dataJson['creator'] as String?,
      characterVersion: dataJson['character_version'] as String? ?? dataJson['characterVersion'] as String?,
      extensions: _parseExtensions(dataJson['extensions'] as Map<String, dynamic>?),
    );

    final now = DateTime.now();
    final card = CharacterCardModel(
      id: _uuid.v4(),
      spec: spec,
      specVersion: specVersion,
      data: data,
      source: CharacterCardSource.imported,
      createdAt: now,
      updatedAt: now,
    );

    await box.put(card.id, card);
    AppLogger.debug('Imported character card: ${card.id}');
    return card;
  }

  /// 导出角色卡为JSON
  /// 
  /// 导出为 chara_card_v2 格式
  @override
  Map<String, dynamic> exportToJson(CharacterCardModel card) {
    return {
      'spec': card.spec,
      'spec_version': card.specVersion,
      'data': {
        'name': card.data.name,
        'description': card.data.description,
        'personality': card.data.personality,
        'scenario': card.data.scenario,
        'first_mes': card.data.firstMes,
        'mes_example': card.data.mesExample,
        'creator_notes': card.data.creatorNotes,
        'system_prompt': card.data.systemPrompt,
        'post_history_instructions': card.data.postHistoryInstructions,
        'alternate_greetings': card.data.alternateGreetings,
        'tags': card.data.tags,
        'creator': card.data.creator,
        'character_version': card.data.characterVersion,
        'extensions': card.data.extensions != null
            ? {
                'avatarUrl': card.data.extensions!.avatarUrl,
                'portraitUrl': card.data.extensions!.portraitUrl,
                'nickname': card.data.extensions!.nickname,
                'profile': card.data.extensions!.profile != null
                    ? {
                        'age': card.data.extensions!.profile!.age,
                        'gender': card.data.extensions!.profile!.gender,
                        'occupation': card.data.extensions!.profile!.occupation,
                        'height': card.data.extensions!.profile!.height,
                        'birthday': card.data.extensions!.profile!.birthday,
                        'likes': card.data.extensions!.profile!.likes,
                        'dislikes': card.data.extensions!.profile!.dislikes,
                        'voiceDescription': card.data.extensions!.profile!.voiceDescription,
                      }
                    : null,
                'custom': card.data.extensions!.custom,
              }
            : null,
      },
    };
  }

  /// 解析扩展字段
  CharacterExtensionsModel? _parseExtensions(Map<String, dynamic>? json) {
    if (json == null) return null;

    return CharacterExtensionsModel(
      avatarUrl: json['avatarUrl'] as String? ?? json['avatar_url'] as String?,
      portraitUrl: json['portraitUrl'] as String? ?? json['portrait_url'] as String?,
      nickname: json['nickname'] as String?,
      profile: _parseProfile(json['profile'] as Map<String, dynamic>?),
      custom: json['custom'] as Map<String, dynamic>?,
    );
  }

  /// 解析角色档案
  CharacterProfileModel? _parseProfile(Map<String, dynamic>? json) {
    if (json == null) return null;

    return CharacterProfileModel(
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      occupation: json['occupation'] as String?,
      height: json['height'] as String?,
      birthday: json['birthday'] as String?,
      likes: (json['likes'] as List?)?.cast<String>() ?? [],
      dislikes: (json['dislikes'] as List?)?.cast<String>() ?? [],
      voiceDescription: json['voiceDescription'] as String? ?? json['voice_description'] as String?,
    );
  }
}

/// 角色卡仓库 Provider
final characterCardRepositoryProvider = Provider<CharacterCardRepository>((ref) {
  return CharacterCardRepositoryImpl();
});

/// 角色卡仓库初始化 Provider
final characterCardRepositoryInitProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(characterCardRepositoryProvider) as CharacterCardRepositoryImpl;
  await repository.init();
});

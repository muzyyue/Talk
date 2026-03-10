import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/features/character_card/domain/entities/character_card.dart';
import 'package:talk/features/character_card/domain/usecases/get_character_cards_usecase.dart';

/// 角色卡列表状态
class CharacterCardListState {
  final List<CharacterCard> cards;
  final bool isLoading;
  final String? error;

  const CharacterCardListState({
    this.cards = const [],
    this.isLoading = false,
    this.error,
  });

  CharacterCardListState copyWith({
    List<CharacterCard>? cards,
    bool? isLoading,
    String? error,
  }) {
    return CharacterCardListState(
      cards: cards ?? this.cards,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 角色卡列表状态管理
class CharacterCardListNotifier extends StateNotifier<CharacterCardListState> {
  final GetCharacterCardsUseCase _getCardsUseCase;
  final DeleteCharacterCardUseCase _deleteCardUseCase;

  CharacterCardListNotifier(
    this._getCardsUseCase,
    this._deleteCardUseCase,
  ) : super(const CharacterCardListState()) {
    loadCards();
  }

  /// 加载角色卡列表
  Future<void> loadCards() async {
    state = state.copyWith(isLoading: true);
    try {
      final cards = await _getCardsUseCase();
      state = CharacterCardListState(cards: cards);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 刷新列表
  Future<void> refresh() async {
    await loadCards();
  }

  /// 删除角色卡
  Future<void> deleteCard(String id) async {
    try {
      await _deleteCardUseCase(id);
      state = state.copyWith(
        cards: state.cards.where((card) => card.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// 角色卡列表 Provider
final characterCardListProvider =
    StateNotifierProvider<CharacterCardListNotifier, CharacterCardListState>(
  (ref) => CharacterCardListNotifier(
    ref.watch(getCharacterCardsUseCaseProvider),
    ref.watch(deleteCharacterCardUseCaseProvider),
  ),
);

/// 当前选中的角色卡 Provider
final selectedCardProvider = StateProvider<CharacterCard?>((ref) => null);

/// 角色卡表单数据
class CharacterCardFormData {
  final String? id;
  final String name;
  final String? description;
  final String? personality;
  final String? scenario;
  final String? firstMes;
  final String? mesExample;
  final String? creatorNotes;
  final String? systemPrompt;
  final List<String> tags;
  final String? avatarUrl;
  final String? portraitUrl;
  final String? nickname;
  final bool isLoading;
  final String? error;

  const CharacterCardFormData({
    this.id,
    this.name = '',
    this.description,
    this.personality,
    this.scenario,
    this.firstMes,
    this.mesExample,
    this.creatorNotes,
    this.systemPrompt,
    this.tags = const [],
    this.avatarUrl,
    this.portraitUrl,
    this.nickname,
    this.isLoading = false,
    this.error,
  });

  /// 从角色卡实体创建表单数据
  factory CharacterCardFormData.fromEntity(CharacterCard card) {
    return CharacterCardFormData(
      id: card.id,
      name: card.name,
      description: card.description,
      personality: card.personality,
      scenario: card.scenario,
      firstMes: card.firstMes,
      mesExample: card.mesExample,
      creatorNotes: card.creatorNotes,
      systemPrompt: card.systemPrompt,
      tags: card.tags,
      avatarUrl: card.avatarUrl,
      portraitUrl: card.portraitUrl,
      nickname: card.nickname,
    );
  }

  /// 转换为角色卡实体
  CharacterCard toEntity() {
    return CharacterCard(
      id: id ?? '',
      name: name,
      description: description,
      personality: personality,
      scenario: scenario,
      firstMes: firstMes,
      mesExample: mesExample,
      creatorNotes: creatorNotes,
      systemPrompt: systemPrompt,
      tags: tags,
      avatarUrl: avatarUrl,
      portraitUrl: portraitUrl,
      nickname: nickname,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  CharacterCardFormData copyWith({
    String? id,
    String? name,
    String? description,
    String? personality,
    String? scenario,
    String? firstMes,
    String? mesExample,
    String? creatorNotes,
    String? systemPrompt,
    List<String>? tags,
    String? avatarUrl,
    String? portraitUrl,
    String? nickname,
    bool? isLoading,
    String? error,
  }) {
    return CharacterCardFormData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      personality: personality ?? this.personality,
      scenario: scenario ?? this.scenario,
      firstMes: firstMes ?? this.firstMes,
      mesExample: mesExample ?? this.mesExample,
      creatorNotes: creatorNotes ?? this.creatorNotes,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      tags: tags ?? this.tags,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      portraitUrl: portraitUrl ?? this.portraitUrl,
      nickname: nickname ?? this.nickname,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 角色卡表单状态管理
class CharacterCardFormNotifier extends StateNotifier<CharacterCardFormData> {
  final CreateCharacterCardUseCase _createCardUseCase;
  final Ref _ref;

  CharacterCardFormNotifier(
    this._createCardUseCase,
    this._ref,
  ) : super(const CharacterCardFormData());

  /// 初始化表单（编辑模式）
  void init(CharacterCard? card) {
    if (card != null) {
      state = CharacterCardFormData.fromEntity(card);
    }
  }

  /// 更新名称
  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  /// 更新描述
  void updateDescription(String? description) {
    state = state.copyWith(description: description);
  }

  /// 更新性格
  void updatePersonality(String? personality) {
    state = state.copyWith(personality: personality);
  }

  /// 更新场景
  void updateScenario(String? scenario) {
    state = state.copyWith(scenario: scenario);
  }

  /// 更新首次消息
  void updateFirstMes(String? firstMes) {
    state = state.copyWith(firstMes: firstMes);
  }

  /// 更新消息示例
  void updateMesExample(String? mesExample) {
    state = state.copyWith(mesExample: mesExample);
  }

  /// 更新创建者备注
  void updateCreatorNotes(String? creatorNotes) {
    state = state.copyWith(creatorNotes: creatorNotes);
  }

  /// 更新系统提示词
  void updateSystemPrompt(String? systemPrompt) {
    state = state.copyWith(systemPrompt: systemPrompt);
  }

  /// 更新标签
  void updateTags(List<String> tags) {
    state = state.copyWith(tags: tags);
  }

  /// 添加标签
  void addTag(String tag) {
    if (!state.tags.contains(tag)) {
      state = state.copyWith(tags: [...state.tags, tag]);
    }
  }

  /// 移除标签
  void removeTag(String tag) {
    state = state.copyWith(tags: state.tags.where((t) => t != tag).toList());
  }

  /// 更新头像URL
  void updateAvatarUrl(String? avatarUrl) {
    state = state.copyWith(avatarUrl: avatarUrl);
  }

  /// 更新立绘URL
  void updatePortraitUrl(String? portraitUrl) {
    state = state.copyWith(portraitUrl: portraitUrl);
  }

  /// 更新昵称
  void updateNickname(String? nickname) {
    state = state.copyWith(nickname: nickname);
  }

  /// 保存角色卡
  Future<CharacterCard?> save() async {
    if (state.name.isEmpty) {
      state = state.copyWith(error: '角色名称不能为空');
      return null;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final card = await _createCardUseCase(state.toEntity());
      _ref.read(characterCardListProvider.notifier).refresh();
      return card;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 重置表单
  void reset() {
    state = const CharacterCardFormData();
  }
}

/// 角色卡表单 Provider
final characterCardFormProvider =
    StateNotifierProvider<CharacterCardFormNotifier, CharacterCardFormData>(
  (ref) => CharacterCardFormNotifier(
    ref.watch(createCharacterCardUseCaseProvider),
    ref,
  ),
);

/// 导入状态
class ImportState {
  final bool isLoading;
  final String? error;
  final CharacterCard? importedCard;

  const ImportState({
    this.isLoading = false,
    this.error,
    this.importedCard,
  });

  ImportState copyWith({
    bool? isLoading,
    String? error,
    CharacterCard? importedCard,
  }) {
    return ImportState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      importedCard: importedCard,
    );
  }
}

/// 导入状态管理
class ImportNotifier extends StateNotifier<ImportState> {
  final ImportCharacterCardUseCase _importUseCase;
  final Ref _ref;

  ImportNotifier(this._importUseCase, this._ref) : super(const ImportState());

  /// 从JSON字符串导入
  Future<CharacterCard?> importFromJsonString(String jsonString) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final card = await _importUseCase(json);
      _ref.read(characterCardListProvider.notifier).refresh();
      state = state.copyWith(importedCard: card);
      return card;
    } catch (e) {
      state = state.copyWith(error: '导入失败: ${e.toString()}');
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 重置状态
  void reset() {
    state = const ImportState();
  }
}

/// 导入 Provider
final importProvider = StateNotifierProvider<ImportNotifier, ImportState>(
  (ref) => ImportNotifier(
    ref.watch(importCharacterCardUseCaseProvider),
    ref,
  ),
);

/// 导出 Provider
final exportProvider = Provider<ExportCharacterCardUseCase>(
  (ref) => ref.watch(exportCharacterCardUseCaseProvider),
);

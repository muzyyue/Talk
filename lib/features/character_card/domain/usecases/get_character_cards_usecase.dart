import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/features/character_card/domain/entities/character_card.dart';
import 'package:talk/features/character_card/data/repositories/character_card_repository.dart';

/// 获取角色卡列表用例
class GetCharacterCardsUseCase {
  final CharacterCardRepository _repository;

  GetCharacterCardsUseCase(this._repository);

  Future<List<CharacterCard>> call() async {
    // 确保仓库已初始化
    if (_repository is CharacterCardRepositoryImpl) {
      await (_repository as CharacterCardRepositoryImpl).ensureInitialized();
    }
    final models = await _repository.getAll();
    return models.map<CharacterCard>(CharacterCard.fromModel).toList();
  }
}

/// 获取角色卡列表用例 Provider
final getCharacterCardsUseCaseProvider = Provider<GetCharacterCardsUseCase>(
  (ref) => GetCharacterCardsUseCase(ref.watch(characterCardRepositoryProvider)),
);

/// 获取单个角色卡详情用例
class GetCharacterCardDetailUseCase {
  final CharacterCardRepository _repository;

  GetCharacterCardDetailUseCase(this._repository);

  Future<CharacterCard?> call(String id) async {
    final model = await _repository.getById(id);
    return model != null ? CharacterCard.fromModel(model) : null;
  }
}

/// 获取角色卡详情用例 Provider
final getCharacterCardDetailUseCaseProvider = Provider<GetCharacterCardDetailUseCase>(
  (ref) => GetCharacterCardDetailUseCase(ref.watch(characterCardRepositoryProvider)),
);

/// 创建角色卡用例
class CreateCharacterCardUseCase {
  final CharacterCardRepository _repository;

  CreateCharacterCardUseCase(this._repository);

  Future<CharacterCard> call(CharacterCard card) async {
    final model = await _repository.save(card.toModel());
    return CharacterCard.fromModel(model);
  }
}

/// 创建角色卡用例 Provider
final createCharacterCardUseCaseProvider = Provider<CreateCharacterCardUseCase>(
  (ref) => CreateCharacterCardUseCase(ref.watch(characterCardRepositoryProvider)),
);

/// 更新角色卡用例
class UpdateCharacterCardUseCase {
  final CharacterCardRepository _repository;

  UpdateCharacterCardUseCase(this._repository);

  Future<CharacterCard> call(CharacterCard card) async {
    final model = await _repository.save(card.toModel());
    return CharacterCard.fromModel(model);
  }
}

/// 更新角色卡用例 Provider
final updateCharacterCardUseCaseProvider = Provider<UpdateCharacterCardUseCase>(
  (ref) => UpdateCharacterCardUseCase(ref.watch(characterCardRepositoryProvider)),
);

/// 删除角色卡用例
class DeleteCharacterCardUseCase {
  final CharacterCardRepository _repository;

  DeleteCharacterCardUseCase(this._repository);

  Future<void> call(String id) async {
    await _repository.delete(id);
  }
}

/// 删除角色卡用例 Provider
final deleteCharacterCardUseCaseProvider = Provider<DeleteCharacterCardUseCase>(
  (ref) => DeleteCharacterCardUseCase(ref.watch(characterCardRepositoryProvider)),
);

/// 导入角色卡用例
class ImportCharacterCardUseCase {
  final CharacterCardRepository _repository;

  ImportCharacterCardUseCase(this._repository);

  Future<CharacterCard> call(Map<String, dynamic> json) async {
    final model = await _repository.importFromJson(json);
    return CharacterCard.fromModel(model);
  }
}

/// 导入角色卡用例 Provider
final importCharacterCardUseCaseProvider = Provider<ImportCharacterCardUseCase>(
  (ref) => ImportCharacterCardUseCase(ref.watch(characterCardRepositoryProvider)),
);

/// 导出角色卡用例
class ExportCharacterCardUseCase {
  final CharacterCardRepository _repository;

  ExportCharacterCardUseCase(this._repository);

  Map<String, dynamic> call(CharacterCard card) {
    return _repository.exportToJson(card.toModel());
  }
}

/// 导出角色卡用例 Provider
final exportCharacterCardUseCaseProvider = Provider<ExportCharacterCardUseCase>(
  (ref) => ExportCharacterCardUseCase(ref.watch(characterCardRepositoryProvider)),
);

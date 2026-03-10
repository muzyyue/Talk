import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/features/character_card/data/repositories/character_card_repository.dart';

/// 角色卡服务
/// 
/// 提供角色卡的业务逻辑处理
class CharacterCardService {
  final CharacterCardRepository _repository;

  CharacterCardService(this._repository);

  Future<List<dynamic>> getAllCards() async {
    return await _repository.getAll();
  }

  Future<dynamic> getCardById(String id) async {
    return await _repository.getById(id);
  }

  Future<void> saveCard(dynamic card) async {
    await _repository.save(card);
  }

  Future<void> deleteCard(String id) async {
    await _repository.delete(id);
  }
}

/// 角色卡服务 Provider
final characterCardServiceProvider = Provider<CharacterCardService>(
  (ref) => CharacterCardService(ref.watch(characterCardRepositoryProvider)),
);

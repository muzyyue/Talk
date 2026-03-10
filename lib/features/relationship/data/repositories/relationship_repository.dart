import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/features/relationship/data/models/relationship_model.dart';

/// 关系仓库
abstract class RelationshipRepository {
  Future<CharacterRelationshipModel?> getByCharacterId(String characterId);
  Future<void> save(CharacterRelationshipModel relationship);
  Future<void> updateAffection(String characterId, int change, String reason);
}

/// 关系仓库实现
class RelationshipRepositoryImpl implements RelationshipRepository {
  @override
  Future<CharacterRelationshipModel?> getByCharacterId(String characterId) async => null;

  @override
  Future<void> save(CharacterRelationshipModel relationship) async {}

  @override
  Future<void> updateAffection(String characterId, int change, String reason) async {}
}

/// 关系仓库 Provider
final relationshipRepositoryProvider = Provider<RelationshipRepository>(
  (ref) => RelationshipRepositoryImpl(),
);

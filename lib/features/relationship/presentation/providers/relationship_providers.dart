import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/features/relationship/domain/entities/relationship.dart';

/// 关系状态
class RelationshipState {
  final Map<String, CharacterRelationship> relationships;
  final bool isLoading;

  const RelationshipState({
    this.relationships = const {},
    this.isLoading = false,
  });
}

/// 关系状态管理
class RelationshipNotifier extends StateNotifier<RelationshipState> {
  RelationshipNotifier() : super(const RelationshipState());

  void updateAffection(String characterId, int change) {
    final current = state.relationships[characterId];
    if (current == null) return;

    final newAffection = (current.affection + change).clamp(0, 100);
    final newLevel = _calculateLevel(newAffection);

    final updated = current.copyWith(
      affection: newAffection,
      level: newLevel,
      lastInteractionAt: DateTime.now(),
    );

    state = RelationshipState(
      relationships: {
        ...state.relationships,
        characterId: updated,
      },
    );
  }

  RelationshipLevel _calculateLevel(int affection) {
    if (affection >= 81) return RelationshipLevel.lover;
    if (affection >= 61) return RelationshipLevel.closeFriend;
    if (affection >= 41) return RelationshipLevel.friend;
    if (affection >= 21) return RelationshipLevel.acquaintance;
    return RelationshipLevel.stranger;
  }
}

/// 关系 Provider
final relationshipProvider =
    StateNotifierProvider<RelationshipNotifier, RelationshipState>(
  (ref) => RelationshipNotifier(),
);

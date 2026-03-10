/// 角色关系实体
class CharacterRelationship {
  final String characterCardId;
  final int affection;
  final RelationshipLevel level;
  final List<RelationshipEvent> events;
  final DateTime firstMetAt;
  final DateTime? lastInteractionAt;

  const CharacterRelationship({
    required this.characterCardId,
    this.affection = 0,
    this.level = RelationshipLevel.stranger,
    this.events = const [],
    required this.firstMetAt,
    this.lastInteractionAt,
  });

  CharacterRelationship copyWith({
    String? characterCardId,
    int? affection,
    RelationshipLevel? level,
    List<RelationshipEvent>? events,
    DateTime? firstMetAt,
    DateTime? lastInteractionAt,
  }) {
    return CharacterRelationship(
      characterCardId: characterCardId ?? this.characterCardId,
      affection: affection ?? this.affection,
      level: level ?? this.level,
      events: events ?? this.events,
      firstMetAt: firstMetAt ?? this.firstMetAt,
      lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
    );
  }
}

/// 关系等级
enum RelationshipLevel {
  stranger,
  acquaintance,
  friend,
  closeFriend,
  lover,
}

/// 关系事件
class RelationshipEvent {
  final String id;
  final String type;
  final String description;
  final int affectionChange;
  final DateTime timestamp;

  const RelationshipEvent({
    required this.id,
    required this.type,
    required this.description,
    required this.affectionChange,
    required this.timestamp,
  });
}

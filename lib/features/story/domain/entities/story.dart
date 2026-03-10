/// 剧情章节实体
class StoryChapter {
  final String id;
  final String title;
  final String? description;
  final StoryType type;
  final String? characterId;
  final bool isCompleted;
  final DateTime createdAt;

  const StoryChapter({
    required this.id,
    required this.title,
    this.description,
    this.type = StoryType.main,
    this.characterId,
    this.isCompleted = false,
    required this.createdAt,
  });

  StoryChapter copyWith({
    String? id,
    String? title,
    String? description,
    StoryType? type,
    String? characterId,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return StoryChapter(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      characterId: characterId ?? this.characterId,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// 剧情类型
enum StoryType {
  main,
  side,
  character,
  event,
}

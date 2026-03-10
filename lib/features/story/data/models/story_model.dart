import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

/// 剧情章节模型
@freezed
class StoryChapterModel with _$StoryChapterModel {
  const factory StoryChapterModel({
    required String id,
    required String title,
    String? description,
    @Default(StoryType.main) StoryType type,
    String? characterId,
    @Default([]) List<String> dialogueIds,
    @Default(false) bool isCompleted,
    required DateTime createdAt,
  }) = _StoryChapterModel;

  factory StoryChapterModel.fromJson(Map<String, dynamic> json) =>
      _$StoryChapterModelFromJson(json);
}

/// 剧情类型
enum StoryType {
  main,
  side,
  character,
  event,
}

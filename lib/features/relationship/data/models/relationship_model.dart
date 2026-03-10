import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship_model.freezed.dart';
part 'relationship_model.g.dart';

/// 角色关系模型
@freezed
class CharacterRelationshipModel with _$CharacterRelationshipModel {
  const factory CharacterRelationshipModel({
    required String characterCardId,
    @Default(0) int affection,
    @Default(RelationshipLevel.stranger) RelationshipLevel level,
    @Default([]) List<RelationshipEventModel> events,
    @Default([]) List<String> unlockedContent,
    required DateTime firstMetAt,
    DateTime? lastInteractionAt,
  }) = _CharacterRelationshipModel;

  factory CharacterRelationshipModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterRelationshipModelFromJson(json);
}

/// 关系等级
enum RelationshipLevel {
  stranger,
  acquaintance,
  friend,
  closeFriend,
  lover,
}

/// 关系事件模型
@freezed
class RelationshipEventModel with _$RelationshipEventModel {
  const factory RelationshipEventModel({
    required String id,
    required String type,
    required String description,
    required int affectionChange,
    required DateTime timestamp,
  }) = _RelationshipEventModel;

  factory RelationshipEventModel.fromJson(Map<String, dynamic> json) =>
      _$RelationshipEventModelFromJson(json);
}

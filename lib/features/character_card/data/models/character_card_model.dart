import 'package:freezed_annotation/freezed_annotation.dart';

part 'character_card_model.freezed.dart';
part 'character_card_model.g.dart';

/// 角色卡来源
enum CharacterCardSource {
  created,
  imported,
  shared,
}

/// 角色卡数据模型
/// 
/// 兼容 chara_card_v2 格式
@freezed
class CharacterCardModel with _$CharacterCardModel {
  const factory CharacterCardModel({
    required String id,
    @Default('chara_card_v2') String spec,
    @Default('2.0') String specVersion,
    required CharacterCardDataModel data,
    @Default(CharacterCardSource.created) CharacterCardSource source,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CharacterCardModel;

  factory CharacterCardModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterCardModelFromJson(json);
}

/// 角色卡数据
@freezed
class CharacterCardDataModel with _$CharacterCardDataModel {
  const factory CharacterCardDataModel({
    required String name,
    String? description,
    String? personality,
    String? scenario,
    String? firstMes,
    String? mesExample,
    String? creatorNotes,
    String? systemPrompt,
    String? postHistoryInstructions,
    String? alternateGreetings,
    @Default([]) List<String> tags,
    String? creator,
    String? characterVersion,
    CharacterExtensionsModel? extensions,
  }) = _CharacterCardDataModel;

  factory CharacterCardDataModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterCardDataModelFromJson(json);
}

/// 角色卡扩展字段
@freezed
class CharacterExtensionsModel with _$CharacterExtensionsModel {
  const factory CharacterExtensionsModel({
    String? avatarUrl,
    String? portraitUrl,
    String? nickname,
    CharacterProfileModel? profile,
    Map<String, dynamic>? custom,
  }) = _CharacterExtensionsModel;

  factory CharacterExtensionsModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterExtensionsModelFromJson(json);
}

/// 角色档案
@freezed
class CharacterProfileModel with _$CharacterProfileModel {
  const factory CharacterProfileModel({
    int? age,
    String? gender,
    String? occupation,
    String? height,
    String? birthday,
    @Default([]) List<String> likes,
    @Default([]) List<String> dislikes,
    String? voiceDescription,
  }) = _CharacterProfileModel;

  factory CharacterProfileModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterProfileModelFromJson(json);
}

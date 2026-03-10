import 'package:talk/features/character_card/data/models/character_card_model.dart';

/// 角色卡实体
/// 
/// 定义角色卡的核心属性，用于展示层使用
class CharacterCard {
  final String id;
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
  final CharacterProfile? profile;
  final CharacterCardSource source;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CharacterCard({
    required this.id,
    required this.name,
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
    this.profile,
    this.source = CharacterCardSource.created,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从 Model 转换为 Entity
  factory CharacterCard.fromModel(CharacterCardModel model) {
    return CharacterCard(
      id: model.id,
      name: model.data.name,
      description: model.data.description,
      personality: model.data.personality,
      scenario: model.data.scenario,
      firstMes: model.data.firstMes,
      mesExample: model.data.mesExample,
      creatorNotes: model.data.creatorNotes,
      systemPrompt: model.data.systemPrompt,
      tags: model.data.tags,
      avatarUrl: model.data.extensions?.avatarUrl,
      portraitUrl: model.data.extensions?.portraitUrl,
      nickname: model.data.extensions?.nickname,
      profile: model.data.extensions?.profile != null
          ? CharacterProfile.fromModel(model.data.extensions!.profile!)
          : null,
      source: model.source,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// 转换为 Model
  CharacterCardModel toModel() {
    return CharacterCardModel(
      id: id,
      data: CharacterCardDataModel(
        name: name,
        description: description,
        personality: personality,
        scenario: scenario,
        firstMes: firstMes,
        mesExample: mesExample,
        creatorNotes: creatorNotes,
        systemPrompt: systemPrompt,
        tags: tags,
        extensions: CharacterExtensionsModel(
          avatarUrl: avatarUrl,
          portraitUrl: portraitUrl,
          nickname: nickname,
          profile: profile?.toModel(),
        ),
      ),
      source: source,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  CharacterCard copyWith({
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
    CharacterProfile? profile,
    CharacterCardSource? source,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CharacterCard(
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
      profile: profile ?? this.profile,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 角色档案实体
class CharacterProfile {
  final int? age;
  final String? gender;
  final String? occupation;
  final String? height;
  final String? birthday;
  final List<String> likes;
  final List<String> dislikes;
  final String? voiceDescription;

  const CharacterProfile({
    this.age,
    this.gender,
    this.occupation,
    this.height,
    this.birthday,
    this.likes = const [],
    this.dislikes = const [],
    this.voiceDescription,
  });

  /// 从 Model 转换
  factory CharacterProfile.fromModel(CharacterProfileModel model) {
    return CharacterProfile(
      age: model.age,
      gender: model.gender,
      occupation: model.occupation,
      height: model.height,
      birthday: model.birthday,
      likes: model.likes,
      dislikes: model.dislikes,
      voiceDescription: model.voiceDescription,
    );
  }

  /// 转换为 Model
  CharacterProfileModel toModel() {
    return CharacterProfileModel(
      age: age,
      gender: gender,
      occupation: occupation,
      height: height,
      birthday: birthday,
      likes: likes,
      dislikes: dislikes,
      voiceDescription: voiceDescription,
    );
  }
}

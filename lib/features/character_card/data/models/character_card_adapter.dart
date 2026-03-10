import 'package:hive/hive.dart';
import 'character_card_model.dart';

/// 角色卡 Hive TypeAdapter
/// 
/// 用于 CharacterCardModel 的 Hive 序列化/反序列化
class CharacterCardModelAdapter extends TypeAdapter<CharacterCardModel> {
  @override
  final int typeId = 0;

  @override
  CharacterCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterCardModel(
      id: fields[0] as String,
      spec: fields[1] as String? ?? 'chara_card_v2',
      specVersion: fields[2] as String? ?? '2.0',
      data: fields[3] as CharacterCardDataModel,
      source: fields[4] as CharacterCardSource? ?? CharacterCardSource.created,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterCardModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.spec)
      ..writeByte(2)
      ..write(obj.specVersion)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.source)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// 角色卡数据 Hive TypeAdapter
class CharacterCardDataModelAdapter extends TypeAdapter<CharacterCardDataModel> {
  @override
  final int typeId = 1;

  @override
  CharacterCardDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterCardDataModel(
      name: fields[0] as String,
      description: fields[1] as String?,
      personality: fields[2] as String?,
      scenario: fields[3] as String?,
      firstMes: fields[4] as String?,
      mesExample: fields[5] as String?,
      creatorNotes: fields[6] as String?,
      systemPrompt: fields[7] as String?,
      postHistoryInstructions: fields[8] as String?,
      alternateGreetings: fields[9] as String?,
      tags: (fields[10] as List?)?.cast<String>() ?? [],
      creator: fields[11] as String?,
      characterVersion: fields[12] as String?,
      extensions: fields[13] as CharacterExtensionsModel?,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterCardDataModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.personality)
      ..writeByte(3)
      ..write(obj.scenario)
      ..writeByte(4)
      ..write(obj.firstMes)
      ..writeByte(5)
      ..write(obj.mesExample)
      ..writeByte(6)
      ..write(obj.creatorNotes)
      ..writeByte(7)
      ..write(obj.systemPrompt)
      ..writeByte(8)
      ..write(obj.postHistoryInstructions)
      ..writeByte(9)
      ..write(obj.alternateGreetings)
      ..writeByte(10)
      ..write(obj.tags)
      ..writeByte(11)
      ..write(obj.creator)
      ..writeByte(12)
      ..write(obj.characterVersion)
      ..writeByte(13)
      ..write(obj.extensions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterCardDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// 角色卡扩展字段 Hive TypeAdapter
class CharacterExtensionsModelAdapter extends TypeAdapter<CharacterExtensionsModel> {
  @override
  final int typeId = 2;

  @override
  CharacterExtensionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterExtensionsModel(
      avatarUrl: fields[0] as String?,
      portraitUrl: fields[1] as String?,
      nickname: fields[2] as String?,
      profile: fields[3] as CharacterProfileModel?,
      custom: fields[4] as Map<String, dynamic>?,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterExtensionsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.avatarUrl)
      ..writeByte(1)
      ..write(obj.portraitUrl)
      ..writeByte(2)
      ..write(obj.nickname)
      ..writeByte(3)
      ..write(obj.profile)
      ..writeByte(4)
      ..write(obj.custom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterExtensionsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// 角色档案 Hive TypeAdapter
class CharacterProfileModelAdapter extends TypeAdapter<CharacterProfileModel> {
  @override
  final int typeId = 3;

  @override
  CharacterProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterProfileModel(
      age: fields[0] as int?,
      gender: fields[1] as String?,
      occupation: fields[2] as String?,
      height: fields[3] as String?,
      birthday: fields[4] as String?,
      likes: (fields[5] as List?)?.cast<String>() ?? [],
      dislikes: (fields[6] as List?)?.cast<String>() ?? [],
      voiceDescription: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterProfileModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.age)
      ..writeByte(1)
      ..write(obj.gender)
      ..writeByte(2)
      ..write(obj.occupation)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.birthday)
      ..writeByte(5)
      ..write(obj.likes)
      ..writeByte(6)
      ..write(obj.dislikes)
      ..writeByte(7)
      ..write(obj.voiceDescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// 角色卡来源 Hive TypeAdapter
class CharacterCardSourceAdapter extends TypeAdapter<CharacterCardSource> {
  @override
  final int typeId = 4;

  @override
  CharacterCardSource read(BinaryReader reader) {
    return CharacterCardSource.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, CharacterCardSource obj) {
    writer.writeByte(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterCardSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

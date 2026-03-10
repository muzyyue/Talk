import 'package:hive/hive.dart';
import 'chat_session_model.dart';

/// 对话会话 Hive TypeAdapter
class ChatSessionModelAdapter extends TypeAdapter<ChatSessionModel> {
  @override
  final int typeId = 10;

  @override
  ChatSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatSessionModel(
      id: fields[0] as String,
      characterCardId: fields[1] as String,
      messages: (fields[2] as List?)?.cast<ChatMessageModel>() ?? [],
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChatSessionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.characterCardId)
      ..writeByte(2)
      ..write(obj.messages)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// 对话消息 Hive TypeAdapter
class ChatMessageModelAdapter extends TypeAdapter<ChatMessageModel> {
  @override
  final int typeId = 11;

  @override
  ChatMessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessageModel(
      id: fields[0] as String,
      role: fields[1] as MessageRole,
      content: fields[2] as String,
      timestamp: fields[3] as DateTime,
      metadata: fields[4] as MessageMetadataModel?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessageModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// 消息角色 Hive TypeAdapter
class MessageRoleAdapter extends TypeAdapter<MessageRole> {
  @override
  final int typeId = 12;

  @override
  MessageRole read(BinaryReader reader) {
    return MessageRole.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, MessageRole obj) {
    writer.writeByte(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// 消息元数据 Hive TypeAdapter
class MessageMetadataModelAdapter extends TypeAdapter<MessageMetadataModel> {
  @override
  final int typeId = 13;

  @override
  MessageMetadataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageMetadataModel(
      emotion: fields[0] as String?,
      expression: fields[1] as String?,
      action: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageMetadataModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.emotion)
      ..writeByte(1)
      ..write(obj.expression)
      ..writeByte(2)
      ..write(obj.action);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageMetadataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

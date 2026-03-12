import 'package:hive/hive.dart';
import 'api_config_model.dart';

/// API 配置 Hive TypeAdapter
class APIConfigModelAdapter extends TypeAdapter<APIConfigModel> {
  @override
  final int typeId = 30;

  @override
  APIConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return APIConfigModel(
      provider: APIProviderType.values[fields[0] as int? ?? 0],
      baseUrl: fields[1] as String? ?? 'http://localhost:1234',
      apiKey: fields[2] as String? ?? '',
      model: fields[3] as String? ?? '',
      temperature: fields[4] as double? ?? 0.8,
      maxTokens: fields[5] as int? ?? 500,
      streamEnabled: fields[6] as bool? ?? true,
      timeoutSeconds: fields[7] as int? ?? 30,
    );
  }

  @override
  void write(BinaryWriter writer, APIConfigModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.provider.index)
      ..writeByte(1)
      ..write(obj.baseUrl)
      ..writeByte(2)
      ..write(obj.apiKey)
      ..writeByte(3)
      ..write(obj.model)
      ..writeByte(4)
      ..write(obj.temperature)
      ..writeByte(5)
      ..write(obj.maxTokens)
      ..writeByte(6)
      ..write(obj.streamEnabled)
      ..writeByte(7)
      ..write(obj.timeoutSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is APIConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

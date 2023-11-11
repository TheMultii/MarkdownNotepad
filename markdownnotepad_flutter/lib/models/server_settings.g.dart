// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerSettingsAdapter extends TypeAdapter<ServerSettings> {
  @override
  final int typeId = 0;

  @override
  ServerSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServerSettings(
      ipAddress: fields[0] as String,
      port: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ServerSettings obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ipAddress)
      ..writeByte(1)
      ..write(obj.port);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extension.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MDNExtensionAdapter extends TypeAdapter<MDNExtension> {
  @override
  final int typeId = 9;

  @override
  MDNExtension read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MDNExtension(
      title: fields[0] as String,
      version: fields[1] as String,
      author: fields[2] as String,
      status: fields[3] as ExtensionStatus,
      activator: fields[4] as String,
      content: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MDNExtension obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.version)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.activator)
      ..writeByte(5)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MDNExtensionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MDNExtension _$MDNExtensionFromJson(Map<String, dynamic> json) => MDNExtension(
      title: json['title'] as String,
      version: json['version'] as String,
      author: json['author'] as String,
      status: $enumDecode(_$ExtensionStatusEnumMap, json['status']),
      activator: json['activator'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$MDNExtensionToJson(MDNExtension instance) =>
    <String, dynamic>{
      'title': instance.title,
      'version': instance.version,
      'author': instance.author,
      'status': _$ExtensionStatusEnumMap[instance.status]!,
      'activator': instance.activator,
      'content': instance.content,
    };

const _$ExtensionStatusEnumMap = {
  ExtensionStatus.active: 'active',
  ExtensionStatus.inactive: 'inactive',
  ExtensionStatus.invalid: 'invalid',
};

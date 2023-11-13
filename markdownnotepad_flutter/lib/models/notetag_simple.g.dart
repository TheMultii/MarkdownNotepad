// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notetag_simple.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteTagSimpleAdapter extends TypeAdapter<NoteTagSimple> {
  @override
  final int typeId = 7;

  @override
  NoteTagSimple read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteTagSimple(
      id: fields[0] as String,
      title: fields[1] as String,
      color: fields[2] as String,
      createdAt: fields[3] as String,
      updatedAt: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NoteTagSimple obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.color)
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
      other is NoteTagSimpleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteTagSimple _$NoteTagSimpleFromJson(Map<String, dynamic> json) =>
    NoteTagSimple(
      id: json['id'] as String,
      title: json['title'] as String,
      color: json['color'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$NoteTagSimpleToJson(NoteTagSimple instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'color': instance.color,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

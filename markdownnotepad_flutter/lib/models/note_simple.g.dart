// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_simple.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteSimpleAdapter extends TypeAdapter<NoteSimple> {
  @override
  final int typeId = 6;

  @override
  NoteSimple read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteSimple(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String?,
      shared: fields[3] as bool,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      localNotePassword: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NoteSimple obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.shared)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.localNotePassword);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteSimpleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteSimple _$NoteSimpleFromJson(Map<String, dynamic> json) => NoteSimple(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String?,
      shared: json['shared'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      localNotePassword: json['localNotePassword'] as String?,
    );

Map<String, dynamic> _$NoteSimpleToJson(NoteSimple instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'shared': instance.shared,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'localNotePassword': instance.localNotePassword,
    };

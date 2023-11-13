// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notetag.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteTagAdapter extends TypeAdapter<NoteTag> {
  @override
  final int typeId = 4;

  @override
  NoteTag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteTag(
      id: fields[0] as String,
      title: fields[1] as String,
      color: fields[2] as String,
      createdAt: fields[3] as String,
      updatedAt: fields[4] as String,
      owner: fields[5] as UserSimple?,
      notes: (fields[6] as List?)?.cast<Note>(),
    );
  }

  @override
  void write(BinaryWriter writer, NoteTag obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.owner)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteTagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteTag _$NoteTagFromJson(Map<String, dynamic> json) => NoteTag(
      id: json['id'] as String,
      title: json['title'] as String,
      color: json['color'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      owner: UserSimple.userFromJson(json['owner'] as Map<String, dynamic>?),
      notes: Note.notesFromJson(json['notes'] as List),
    );

Map<String, dynamic> _$NoteTagToJson(NoteTag instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'color': instance.color,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'owner': UserSimple.userToJson(instance.owner),
      'notes': Note.notesToJson(instance.notes),
    };

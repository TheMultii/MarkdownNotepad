// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 2;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      shared: fields[3] as bool,
      createdAt: fields[4] as String,
      updatedAt: fields[5] as String,
      localNotePassword: fields[6] as String?,
      tags: (fields[7] as List?)?.cast<NoteTag>(),
      user: fields[8] as User?,
      folder: fields[9] as Catalog?,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.localNotePassword)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.user)
      ..writeByte(9)
      ..write(obj.folder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      shared: json['shared'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      localNotePassword: json['localNotePassword'] as String?,
      tags: NoteTag.noteTagsFromJson(json['tags'] as List),
      user: User.userFromJson(json['user'] as Map<String, dynamic>?),
      folder: Catalog.catalogOptionalFromJson(
          json['folder'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'shared': instance.shared,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'localNotePassword': instance.localNotePassword,
      'tags': NoteTag.noteTagsToJson(instance.tags),
      'user': User.userToJson(instance.user),
      'folder': Catalog.catalogOptionalToJson(instance.folder),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      username: fields[1] as String,
      email: fields[2] as String,
      bio: fields[3] as String?,
      name: fields[4] as String,
      surname: fields[5] as String,
      createdAt: fields[6] as String,
      updatedAt: fields[7] as String,
      notes: (fields[8] as List?)?.cast<Note>(),
      tags: (fields[9] as List?)?.cast<NoteTag>(),
      catalogs: (fields[10] as List?)?.cast<Catalog>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.bio)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.surname)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.tags)
      ..writeByte(10)
      ..write(obj.catalogs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
      name: json['name'] as String,
      surname: json['surname'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      notes: Note.notesFromJson(json['notes'] as List),
      tags: NoteTag.noteTagsFromJson(json['tags'] as List),
      catalogs: Catalog.catalogsFromJson(json['catalogs'] as List),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'bio': instance.bio,
      'name': instance.name,
      'surname': instance.surname,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'notes': Note.notesToJson(instance.notes),
      'tags': NoteTag.noteTagsToJson(instance.tags),
      'catalogs': Catalog.catalogsToJson(instance.catalogs),
    };

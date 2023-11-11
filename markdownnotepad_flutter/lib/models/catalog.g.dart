// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CatalogAdapter extends TypeAdapter<Catalog> {
  @override
  final int typeId = 3;

  @override
  Catalog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Catalog(
      id: fields[0] as String,
      title: fields[1] as String,
      createdAt: fields[2] as String,
      updatedAt: fields[3] as String,
      notes: (fields[4] as List?)?.cast<Note>(),
      owner: fields[5] as User?,
    );
  }

  @override
  void write(BinaryWriter writer, Catalog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.owner);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatalogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Catalog _$CatalogFromJson(Map<String, dynamic> json) => Catalog(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      notes: Note.notesFromJson(json['notes'] as List),
      owner: User.userFromJson(json['owner'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$CatalogToJson(Catalog instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'notes': Note.notesToJson(instance.notes),
      'owner': User.userToJson(instance.owner),
    };

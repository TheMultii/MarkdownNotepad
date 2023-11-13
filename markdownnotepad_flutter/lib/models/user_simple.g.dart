// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_simple.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSimpleAdapter extends TypeAdapter<UserSimple> {
  @override
  final int typeId = 8;

  @override
  UserSimple read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSimple(
      id: fields[0] as String,
      username: fields[1] as String,
      email: fields[2] as String,
      bio: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserSimple obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.bio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSimpleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSimple _$UserSimpleFromJson(Map<String, dynamic> json) => UserSimple(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$UserSimpleToJson(UserSimple instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'bio': instance.bio,
    };

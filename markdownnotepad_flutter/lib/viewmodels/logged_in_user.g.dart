// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logged_in_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoggedInUserAdapter extends TypeAdapter<LoggedInUser> {
  @override
  final int typeId = 5;

  @override
  LoggedInUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoggedInUser(
      user: fields[0] as User,
      accessToken: fields[1] as String,
      timeOfLogin: fields[2] as DateTime,
      tokenExpiration: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LoggedInUser obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.user)
      ..writeByte(1)
      ..write(obj.accessToken)
      ..writeByte(2)
      ..write(obj.timeOfLogin)
      ..writeByte(3)
      ..write(obj.tokenExpiration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoggedInUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

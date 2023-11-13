// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extension_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExtensionStatusAdapter extends TypeAdapter<ExtensionStatus> {
  @override
  final int typeId = 11;

  @override
  ExtensionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExtensionStatus.active;
      case 1:
        return ExtensionStatus.inactive;
      case 2:
        return ExtensionStatus.invalid;
      default:
        return ExtensionStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, ExtensionStatus obj) {
    switch (obj) {
      case ExtensionStatus.active:
        writer.writeByte(0);
        break;
      case ExtensionStatus.inactive:
        writer.writeByte(1);
        break;
      case ExtensionStatus.invalid:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtensionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

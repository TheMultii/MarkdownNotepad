// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imported_extensions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImportedExtensionsAdapter extends TypeAdapter<ImportedExtensions> {
  @override
  final int typeId = 10;

  @override
  ImportedExtensions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImportedExtensions(
      extensions: (fields[0] as List).cast<MDNExtension>(),
    );
  }

  @override
  void write(BinaryWriter writer, ImportedExtensions obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.extensions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImportedExtensionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

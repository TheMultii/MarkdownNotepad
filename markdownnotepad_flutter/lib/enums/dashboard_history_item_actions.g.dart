// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_history_item_actions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DashboardHistoryItemActionsAdapter
    extends TypeAdapter<DashboardHistoryItemActions> {
  @override
  final int typeId = 14;

  @override
  DashboardHistoryItemActions read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DashboardHistoryItemActions.createdNote;
      case 1:
        return DashboardHistoryItemActions.editedNote;
      case 2:
        return DashboardHistoryItemActions.deletedNote;
      case 3:
        return DashboardHistoryItemActions.addedTag;
      case 4:
        return DashboardHistoryItemActions.removedTag;
      case 5:
        return DashboardHistoryItemActions.unknown;
      default:
        return DashboardHistoryItemActions.createdNote;
    }
  }

  @override
  void write(BinaryWriter writer, DashboardHistoryItemActions obj) {
    switch (obj) {
      case DashboardHistoryItemActions.createdNote:
        writer.writeByte(0);
        break;
      case DashboardHistoryItemActions.editedNote:
        writer.writeByte(1);
        break;
      case DashboardHistoryItemActions.deletedNote:
        writer.writeByte(2);
        break;
      case DashboardHistoryItemActions.addedTag:
        writer.writeByte(3);
        break;
      case DashboardHistoryItemActions.removedTag:
        writer.writeByte(4);
        break;
      case DashboardHistoryItemActions.unknown:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardHistoryItemActionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

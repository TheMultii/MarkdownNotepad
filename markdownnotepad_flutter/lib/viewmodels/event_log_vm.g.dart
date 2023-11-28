// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_log_vm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventLogVMAdapter extends TypeAdapter<EventLogVM> {
  @override
  final int typeId = 13;

  @override
  EventLogVM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventLogVM(
      id: fields[0] as String,
      action: fields[1] as DashboardHistoryItemActions,
      type: fields[2] as String,
      message: fields[3] as String,
      userId: fields[4] as String,
      noteId: fields[5] as String?,
      noteTitle: fields[6] as String?,
      tagsId: (fields[7] as List).cast<String>(),
      tagsTitles: (fields[8] as List).cast<String>(),
      catalogId: fields[10] as String?,
      catalogTitle: fields[11] as String?,
      ip: fields[12] as String,
      createdAt: fields[13] as DateTime,
      updatedAt: fields[14] as DateTime,
    )
      ..tagsColors = (fields[9] as List).cast<String>()
      ..exists = fields[15] as bool;
  }

  @override
  void write(BinaryWriter writer, EventLogVM obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.action)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.noteId)
      ..writeByte(6)
      ..write(obj.noteTitle)
      ..writeByte(7)
      ..write(obj.tagsId)
      ..writeByte(8)
      ..write(obj.tagsTitles)
      ..writeByte(9)
      ..write(obj.tagsColors)
      ..writeByte(10)
      ..write(obj.catalogId)
      ..writeByte(11)
      ..write(obj.catalogTitle)
      ..writeByte(12)
      ..write(obj.ip)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.exists);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventLogVMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventLogVM _$EventLogVMFromJson(Map<String, dynamic> json) => EventLogVM(
      id: json['id'] as String,
      action: $enumDecode(_$DashboardHistoryItemActionsEnumMap, json['action']),
      type: json['type'] as String,
      message: json['message'] as String,
      userId: json['userId'] as String,
      noteId: json['noteId'] as String?,
      noteTitle: json['noteTitle'] as String?,
      tagsId:
          (json['tagsId'] as List<dynamic>).map((e) => e as String).toList(),
      tagsTitles: (json['tagsTitles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      catalogId: json['catalogId'] as String?,
      catalogTitle: json['catalogTitle'] as String?,
      ip: json['ip'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    )
      ..tagsColors =
          (json['tagsColors'] as List<dynamic>).map((e) => e as String).toList()
      ..exists = json['exists'] as bool;

Map<String, dynamic> _$EventLogVMToJson(EventLogVM instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': _$DashboardHistoryItemActionsEnumMap[instance.action]!,
      'type': instance.type,
      'message': instance.message,
      'userId': instance.userId,
      'noteId': instance.noteId,
      'noteTitle': instance.noteTitle,
      'tagsId': instance.tagsId,
      'tagsTitles': instance.tagsTitles,
      'tagsColors': instance.tagsColors,
      'catalogId': instance.catalogId,
      'catalogTitle': instance.catalogTitle,
      'ip': instance.ip,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'exists': instance.exists,
    };

const _$DashboardHistoryItemActionsEnumMap = {
  DashboardHistoryItemActions.createdNote: 'createdNote',
  DashboardHistoryItemActions.editedNote: 'editedNote',
  DashboardHistoryItemActions.deletedNote: 'deletedNote',
  DashboardHistoryItemActions.addedTag: 'addedTag',
  DashboardHistoryItemActions.removedTag: 'removedTag',
  DashboardHistoryItemActions.unknown: 'unknown',
};

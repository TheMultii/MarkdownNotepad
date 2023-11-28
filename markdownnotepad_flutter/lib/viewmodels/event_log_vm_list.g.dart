// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_log_vm_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventLogVMListAdapter extends TypeAdapter<EventLogVMList> {
  @override
  final int typeId = 15;

  @override
  EventLogVMList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventLogVMList(
      eventLogs: (fields[0] as List?)?.cast<EventLogVM>(),
    );
  }

  @override
  void write(BinaryWriter writer, EventLogVMList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.eventLogs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventLogVMListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventLogVMList _$EventLogVMListFromJson(Map<String, dynamic> json) =>
    EventLogVMList(
      eventLogs: (json['eventLogs'] as List<dynamic>?)
          ?.map((e) => EventLogVM.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventLogVMListToJson(EventLogVMList instance) =>
    <String, dynamic>{
      'eventLogs': instance.eventLogs,
    };

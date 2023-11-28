import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm.dart';

part 'event_log_vm_list.g.dart';

@JsonSerializable()
@HiveType(typeId: 15)
class EventLogVMList extends HiveObject {
  @HiveField(0)
  List<EventLogVM>? eventLogs;

  EventLogVMList({
    this.eventLogs,
  });

  factory EventLogVMList.fromJson(Map<String, dynamic> json) =>
      _$EventLogVMListFromJson(json);

  Map<String, dynamic> toJson() => _$EventLogVMListToJson(this);
}

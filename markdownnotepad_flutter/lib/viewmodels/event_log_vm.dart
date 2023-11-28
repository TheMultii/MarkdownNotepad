import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/enums/dashboard_history_item_actions.dart';
import 'package:markdownnotepad/models/event_log.dart';

part 'event_log_vm.g.dart';

@JsonSerializable()
@HiveType(typeId: 13)
class EventLogVM {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DashboardHistoryItemActions action;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final String message;
  @HiveField(4)
  final String userId;
  @HiveField(5)
  final String? noteId;
  @HiveField(6)
  String? noteTitle;
  @HiveField(7)
  final List<String> tagsId;
  @HiveField(8)
  List<String> tagsTitles;
  @HiveField(9)
  List<String> tagsColors = [];
  @HiveField(10)
  final String? catalogId;
  @HiveField(11)
  String? catalogTitle;
  @HiveField(12)
  final String ip;
  @HiveField(13)
  final DateTime createdAt;
  @HiveField(14)
  final DateTime updatedAt;
  @HiveField(15)
  bool exists = false;

  EventLogVM({
    required this.id,
    required this.action,
    required this.type,
    required this.message,
    required this.userId,
    required this.noteId,
    required this.noteTitle,
    required this.tagsId,
    required this.tagsTitles,
    required this.catalogId,
    required this.catalogTitle,
    required this.ip,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventLogVM.fromJson(Map<String, dynamic> json) =>
      _$EventLogVMFromJson(json);

  factory EventLogVM.fromEventLog(EventLog eventLog) {
    DashboardHistoryItemActions action = DashboardHistoryItemActions.unknown;
    switch (eventLog.type.toLowerCase()) {
      case "create_note":
        action = DashboardHistoryItemActions.createdNote;
        break;
      case "update_note":
        action = DashboardHistoryItemActions.editedNote;
        break;
      case "delete_note":
        action = DashboardHistoryItemActions.deletedNote;
        break;
      case "add_notetags":
        action = DashboardHistoryItemActions.addedTag;
        break;
      case "remove_notetags":
        action = DashboardHistoryItemActions.removedTag;
        break;
      default:
        action = DashboardHistoryItemActions.unknown;
        break;
    }

    return EventLogVM(
      id: eventLog.id,
      action: action,
      type: eventLog.type,
      message: eventLog.message,
      userId: eventLog.userId,
      noteId: eventLog.noteId,
      noteTitle: eventLog.noteTitle,
      tagsId: eventLog.tagsId,
      tagsTitles: eventLog.tagsTitles,
      catalogId: eventLog.catalogId,
      catalogTitle: eventLog.catalogTitle,
      ip: eventLog.ip,
      createdAt: eventLog.createdAt,
      updatedAt: eventLog.updatedAt,
    );
  }
  Map<String, dynamic> toJson() => _$EventLogVMToJson(this);
}

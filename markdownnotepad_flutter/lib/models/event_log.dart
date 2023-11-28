import 'package:json_annotation/json_annotation.dart';

part 'event_log.g.dart';

@JsonSerializable()
class EventLog {
  final String id;
  final String type;
  final String message;
  final String userId;
  final String? noteId;
  final String? noteTitle;
  final List<String> tagsId;
  final List<String> tagsTitles;
  final String? catalogId;
  final String? catalogTitle;
  final String ip;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventLog({
    required this.id,
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

  factory EventLog.fromJson(Map<String, dynamic> json) =>
      _$EventLogFromJson(json);
  Map<String, dynamic> toJson() => _$EventLogToJson(this);

  static List<EventLog> eventLogsFromJson(List<dynamic> json) {
    List<EventLog> eventLogs = [];
    for (var eventLog in json) {
      eventLogs.add(EventLog.fromJson(eventLog));
    }
    return eventLogs;
  }

  static List<Map<String, dynamic>> eventLogsToJson(List<EventLog> eventLogs) {
    List<Map<String, dynamic>> json = [];
    for (var eventLog in eventLogs) {
      json.add(eventLog.toJson());
    }
    return json;
  }

  static EventLog? eventLogFromJson(Map<String, dynamic>? json) =>
      json != null ? EventLog.fromJson(json) : null;

  static Map<String, dynamic>? eventLogToJson(EventLog? eventLog) =>
      eventLog?.toJson();
}

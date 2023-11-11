import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/event_log.dart';

part 'event_logs_response_model.g.dart';

@JsonSerializable()
class EventLogsResponseModel {
  int page;
  int totalPages;
  @JsonKey(
    toJson: EventLog.eventLogsToJson,
    fromJson: EventLog.eventLogsFromJson,
  )
  List<EventLog> eventLogs;

  EventLogsResponseModel({
    required this.page,
    required this.totalPages,
    required this.eventLogs,
  });

  factory EventLogsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$EventLogsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$EventLogsResponseModelToJson(this);
}

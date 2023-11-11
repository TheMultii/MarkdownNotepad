// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_logs_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventLogsResponseModel _$EventLogsResponseModelFromJson(
        Map<String, dynamic> json) =>
    EventLogsResponseModel(
      page: json['page'] as int,
      totalPages: json['totalPages'] as int,
      eventLogs: EventLog.eventLogsFromJson(json['eventLogs'] as List),
    );

Map<String, dynamic> _$EventLogsResponseModelToJson(
        EventLogsResponseModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'totalPages': instance.totalPages,
      'eventLogs': EventLog.eventLogsToJson(instance.eventLogs),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventLog _$EventLogFromJson(Map<String, dynamic> json) => EventLog(
      id: json['id'] as String,
      type: json['type'] as String,
      message: json['message'] as String,
      userId: json['userId'] as String,
      noteId: json['noteId'] as String,
      tagId: json['tagId'] as String,
      catalogId: json['catalogId'] as String,
      ip: json['ip'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$EventLogToJson(EventLog instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'message': instance.message,
      'userId': instance.userId,
      'noteId': instance.noteId,
      'tagId': instance.tagId,
      'catalogId': instance.catalogId,
      'ip': instance.ip,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

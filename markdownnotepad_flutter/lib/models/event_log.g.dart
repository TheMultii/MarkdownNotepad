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
    );

Map<String, dynamic> _$EventLogToJson(EventLog instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'message': instance.message,
      'userId': instance.userId,
      'noteId': instance.noteId,
      'noteTitle': instance.noteTitle,
      'tagsId': instance.tagsId,
      'tagsTitles': instance.tagsTitles,
      'catalogId': instance.catalogId,
      'catalogTitle': instance.catalogTitle,
      'ip': instance.ip,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

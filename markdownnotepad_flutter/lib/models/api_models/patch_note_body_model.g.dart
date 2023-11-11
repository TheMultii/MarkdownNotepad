// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_note_body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchNoteBodyModel _$PatchNoteBodyModelFromJson(Map<String, dynamic> json) =>
    PatchNoteBodyModel(
      title: json['title'] as String?,
      content: json['content'] as String?,
      folderId: json['folderId'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PatchNoteBodyModelToJson(PatchNoteBodyModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'folderId': instance.folderId,
      'tags': instance.tags,
    };

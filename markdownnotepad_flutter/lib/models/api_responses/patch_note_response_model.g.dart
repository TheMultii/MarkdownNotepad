// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_note_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchNoteResponseModel _$PatchNoteResponseModelFromJson(
        Map<String, dynamic> json) =>
    PatchNoteResponseModel(
      message: json['message'] as String,
      note: NoteSimple.noteFromJson(json['note'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PatchNoteResponseModelToJson(
        PatchNoteResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'note': NoteSimple.noteToJson(instance.note),
    };

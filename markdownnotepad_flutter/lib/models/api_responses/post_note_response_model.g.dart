// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_note_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostNoteResponseModel _$PostNoteResponseModelFromJson(
        Map<String, dynamic> json) =>
    PostNoteResponseModel(
      message: json['message'] as String,
      note: NoteSimple.noteFromJson(json['note'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostNoteResponseModelToJson(
        PostNoteResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'note': NoteSimple.noteToJson(instance.note),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_note_tag_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostNoteTagResponseModel _$PostNoteTagResponseModelFromJson(
        Map<String, dynamic> json) =>
    PostNoteTagResponseModel(
      message: json['message'] as String,
      noteTag: NoteTag.noteTagFromJson(json['noteTag'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostNoteTagResponseModelToJson(
        PostNoteTagResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'noteTag': NoteTag.noteTagToJson(instance.noteTag),
    };

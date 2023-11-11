// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_note_tag_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchNoteTagResponseModel _$PatchNoteTagResponseModelFromJson(
        Map<String, dynamic> json) =>
    PatchNoteTagResponseModel(
      message: json['message'] as String,
      noteTag: NoteTag.noteTagFromJson(json['noteTag'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PatchNoteTagResponseModelToJson(
        PatchNoteTagResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'noteTag': NoteTag.noteTagToJson(instance.noteTag),
    };

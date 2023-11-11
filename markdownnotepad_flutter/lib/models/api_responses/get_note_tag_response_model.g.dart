// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_note_tag_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetNoteTagResponseModel _$GetNoteTagResponseModelFromJson(
        Map<String, dynamic> json) =>
    GetNoteTagResponseModel(
      noteTag: NoteTag.noteTagFromJson(json['noteTag'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetNoteTagResponseModelToJson(
        GetNoteTagResponseModel instance) =>
    <String, dynamic>{
      'noteTag': NoteTag.noteTagToJson(instance.noteTag),
    };

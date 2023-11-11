// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_note_tags_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllNoteTagsResponseModel _$GetAllNoteTagsResponseModelFromJson(
        Map<String, dynamic> json) =>
    GetAllNoteTagsResponseModel(
      noteTags: NoteTag.noteTagsFromJson(json['noteTags'] as List),
    );

Map<String, dynamic> _$GetAllNoteTagsResponseModelToJson(
        GetAllNoteTagsResponseModel instance) =>
    <String, dynamic>{
      'noteTags': NoteTag.noteTagsToJson(instance.noteTags),
    };

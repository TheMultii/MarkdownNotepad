// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_note_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetNoteResponseModel _$GetNoteResponseModelFromJson(
        Map<String, dynamic> json) =>
    GetNoteResponseModel(
      note: Note.noteFromJson(json['note'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetNoteResponseModelToJson(
        GetNoteResponseModel instance) =>
    <String, dynamic>{
      'note': Note.noteToJson(instance.note),
    };

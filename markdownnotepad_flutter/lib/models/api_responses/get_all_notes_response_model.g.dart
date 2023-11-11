// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_notes_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllNotesResponseModel _$GetAllNotesResponseModelFromJson(
        Map<String, dynamic> json) =>
    GetAllNotesResponseModel(
      notes: Note.notesFromJson(json['notes'] as List),
    );

Map<String, dynamic> _$GetAllNotesResponseModelToJson(
        GetAllNotesResponseModel instance) =>
    <String, dynamic>{
      'notes': Note.notesToJson(instance.notes),
    };

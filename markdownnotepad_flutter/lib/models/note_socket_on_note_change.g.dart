// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_socket_on_note_change.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteSocketOnNotechange _$NoteSocketOnNotechangeFromJson(
        Map<String, dynamic> json) =>
    NoteSocketOnNotechange(
      note: Note.fromJson(json['note'] as Map<String, dynamic>),
      changeset:
          (json['changeset'] as List<dynamic>).map((e) => e as int).toList(),
      user:
          ConnectedLiveShareUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NoteSocketOnNotechangeToJson(
        NoteSocketOnNotechange instance) =>
    <String, dynamic>{
      'note': instance.note,
      'changeset': instance.changeset,
      'user': instance.user,
    };

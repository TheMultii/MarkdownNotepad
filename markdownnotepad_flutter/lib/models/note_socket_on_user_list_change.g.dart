// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_socket_on_user_list_change.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteSocketOnUserListChange _$NoteSocketOnUserListChangeFromJson(
        Map<String, dynamic> json) =>
    NoteSocketOnUserListChange(
      noteID: json['noteID'] as String,
      connectedUsers: (json['connectedUsers'] as List<dynamic>)
          .map(
              (e) => ConnectedLiveShareUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      user:
          ConnectedLiveShareUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NoteSocketOnUserListChangeToJson(
        NoteSocketOnUserListChange instance) =>
    <String, dynamic>{
      'noteID': instance.noteID,
      'connectedUsers': instance.connectedUsers,
      'user': instance.user,
    };

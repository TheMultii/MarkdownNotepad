import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/viewmodels/connected_live_share_user.dart';

part 'note_socket_on_user_list_change.g.dart';

@JsonSerializable()
class NoteSocketOnUserListChange {
  final String noteID;
  final List<ConnectedLiveShareUser> connectedUsers;
  final ConnectedLiveShareUser user;

  NoteSocketOnUserListChange({
    required this.noteID,
    required this.connectedUsers,
    required this.user,
  });

  factory NoteSocketOnUserListChange.fromJson(Map<String, dynamic> json) =>
      _$NoteSocketOnUserListChangeFromJson(json);
  Map<String, dynamic> toJson() => _$NoteSocketOnUserListChangeToJson(this);
}

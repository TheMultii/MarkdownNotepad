import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/viewmodels/connected_live_share_user.dart';

part 'note_socket_on_note_change.g.dart';

@JsonSerializable()
class NoteSocketOnNotechange {
  final Note note;
  final List<int> changeset;
  final ConnectedLiveShareUser user;

  NoteSocketOnNotechange({
    required this.note,
    required this.changeset,
    required this.user,
  });

  factory NoteSocketOnNotechange.fromJson(Map<String, dynamic> json) =>
      _$NoteSocketOnNotechangeFromJson(json);
  Map<String, dynamic> toJson() => _$NoteSocketOnNotechangeToJson(this);
}

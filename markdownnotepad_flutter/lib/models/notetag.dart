import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/models/user_simple.dart';

part 'notetag.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
class NoteTag extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String color;
  @HiveField(3)
  DateTime createdAt;
  @HiveField(4)
  DateTime updatedAt;
  @HiveField(5)
  @JsonKey(toJson: UserSimple.userToJson, fromJson: UserSimple.userFromJson)
  UserSimple? owner;
  @HiveField(6)
  @JsonKey(toJson: Note.notesToJson, fromJson: Note.notesFromJson)
  List<Note>? notes;

  NoteTag({
    required this.id,
    required this.title,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    required this.owner,
    this.notes,
  });

  factory NoteTag.fromJson(Map<String, dynamic> json) =>
      _$NoteTagFromJson(json);
  Map<String, dynamic> toJson() => _$NoteTagToJson(this);

  static List<NoteTag> noteTagsFromJson(List<dynamic> json) {
    List<NoteTag> noteTags = [];
    for (var noteTag in json) {
      noteTags.add(NoteTag.fromJson(noteTag));
    }
    return noteTags;
  }

  static List<Map<String, dynamic>> noteTagsToJson(List<NoteTag>? noteTags) {
    if (noteTags == null) return [];
    List<Map<String, dynamic>> json = [];
    for (var noteTag in noteTags) {
      json.add(noteTag.toJson());
    }
    return json;
  }

  static NoteTag noteTagFromJson(Map<String, dynamic> json) =>
      NoteTag.fromJson(json);

  static Map<String, dynamic> noteTagToJson(NoteTag noteTag) =>
      noteTag.toJson();
}

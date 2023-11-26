import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/catalog_simple.dart';
import 'package:markdownnotepad/models/notetag_simple.dart';
import 'package:markdownnotepad/models/user.dart';

part 'note.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class Note extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String content;
  @HiveField(3)
  bool shared;
  @HiveField(4)
  DateTime createdAt;
  @HiveField(5)
  DateTime updatedAt;
  @HiveField(6)
  String? localNotePassword;
  @HiveField(7)
  @JsonKey(
    toJson: NoteTagSimple.noteTagsToJson,
    fromJson: NoteTagSimple.noteTagsFromJson,
    defaultValue: null,
  )
  List<NoteTagSimple>? tags;
  @HiveField(8)
  @JsonKey(
    toJson: User.userToJson,
    fromJson: User.userFromJson,
    defaultValue: null,
  )
  User? user;
  @HiveField(9)
  @JsonKey(
    toJson: CatalogSimple.catalogOptionalToJson,
    fromJson: CatalogSimple.catalogOptionalFromJson,
    defaultValue: null,
  )
  CatalogSimple? folder;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.shared,
    required this.createdAt,
    required this.updatedAt,
    this.localNotePassword,
    this.tags,
    this.user,
    this.folder,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);

  static List<Note> notesFromJson(List<dynamic> json) {
    List<Note> notes = [];
    for (var element in json) {
      notes.add(Note.fromJson(element));
    }
    return notes;
  }

  static List<Map<String, dynamic>> notesToJson(List<Note>? notes) {
    if (notes == null) return [];
    List<Map<String, dynamic>> json = [];
    for (var element in notes) {
      json.add(element.toJson());
    }
    return json;
  }

  static Note noteFromJson(Map<String, dynamic> json) => Note.fromJson(json);

  static Map<String, dynamic>? noteToJson(Note note) => note.toJson();
}

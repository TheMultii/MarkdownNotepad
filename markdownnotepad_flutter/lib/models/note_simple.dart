import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note_simple.g.dart';

@JsonSerializable()
@HiveType(typeId: 6)
class NoteSimple extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String? content;
  @HiveField(3)
  bool shared;
  @HiveField(4)
  DateTime createdAt;
  @HiveField(5)
  DateTime updatedAt;
  @HiveField(6)
  String? localNotePassword;

  NoteSimple({
    required this.id,
    required this.title,
    this.content,
    required this.shared,
    required this.createdAt,
    required this.updatedAt,
    this.localNotePassword,
  });

  factory NoteSimple.fromJson(Map<String, dynamic> json) =>
      _$NoteSimpleFromJson(json);
  Map<String, dynamic> toJson() => _$NoteSimpleToJson(this);

  static List<NoteSimple> notesFromJson(List<dynamic> json) {
    List<NoteSimple> notes = [];
    for (var element in json) {
      notes.add(NoteSimple.fromJson(element));
    }
    return notes;
  }

  static List<Map<String, dynamic>> notesToJson(List<NoteSimple>? notes) {
    if (notes == null) return [];
    List<Map<String, dynamic>> json = [];
    for (var element in notes) {
      json.add(element.toJson());
    }
    return json;
  }

  static NoteSimple noteFromJson(Map<String, dynamic> json) =>
      NoteSimple.fromJson(json);

  static Map<String, dynamic>? noteToJson(NoteSimple note) => note.toJson();
}

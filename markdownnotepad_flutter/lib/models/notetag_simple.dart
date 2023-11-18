import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notetag_simple.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class NoteTagSimple extends HiveObject {
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

  NoteTagSimple({
    required this.id,
    required this.title,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteTagSimple.fromJson(Map<String, dynamic> json) =>
      _$NoteTagSimpleFromJson(json);
  Map<String, dynamic> toJson() => _$NoteTagSimpleToJson(this);

  static List<NoteTagSimple> noteTagsFromJson(List<dynamic> json) {
    List<NoteTagSimple> noteTags = [];
    for (var noteTag in json) {
      noteTags.add(NoteTagSimple.fromJson(noteTag));
    }
    return noteTags;
  }

  static List<Map<String, dynamic>> noteTagsToJson(
      List<NoteTagSimple>? noteTags) {
    if (noteTags == null) return [];
    List<Map<String, dynamic>> json = [];
    for (var noteTag in noteTags) {
      json.add(noteTag.toJson());
    }
    return json;
  }

  static NoteTagSimple noteTagFromJson(Map<String, dynamic> json) =>
      NoteTagSimple.fromJson(json);

  static Map<String, dynamic> noteTagToJson(NoteTagSimple noteTag) =>
      noteTag.toJson();
}

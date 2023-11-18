import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/note_simple.dart';
import 'package:markdownnotepad/models/user_simple.dart';

part 'catalog.g.dart';

@JsonSerializable()
@HiveType(typeId: 3)
class Catalog extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  DateTime createdAt;
  @HiveField(3)
  DateTime updatedAt;
  @HiveField(4)
  @JsonKey(toJson: NoteSimple.notesToJson, fromJson: NoteSimple.notesFromJson)
  List<NoteSimple>? notes;
  @HiveField(5)
  @JsonKey(toJson: UserSimple.userToJson, fromJson: UserSimple.userFromJson)
  UserSimple? owner;

  Catalog({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.owner,
  });

  factory Catalog.fromJson(Map<String, dynamic> json) =>
      _$CatalogFromJson(json);
  Map<String, dynamic> toJson() => _$CatalogToJson(this);

  static List<Catalog> catalogsFromJson(List<dynamic> json) {
    List<Catalog> catalogs = [];
    for (var catalog in json) {
      catalogs.add(Catalog.fromJson(catalog));
    }
    return catalogs;
  }

  static List<Map<String, dynamic>> catalogsToJson(List<Catalog>? catalogs) {
    if (catalogs == null) return [];
    List<Map<String, dynamic>> json = [];
    for (var catalog in catalogs) {
      json.add(catalog.toJson());
    }
    return json;
  }

  static Catalog catalogFromJson(Map<String, dynamic> json) =>
      Catalog.fromJson(json);

  static Map<String, dynamic> catalogToJson(Catalog catalog) =>
      catalog.toJson();

  static Catalog? catalogOptionalFromJson(Map<String, dynamic>? json) =>
      json == null ? null : Catalog.fromJson(json);

  static Map<String, dynamic>? catalogOptionalToJson(Catalog? catalog) =>
      catalog?.toJson();
}

import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/catalog_simple.dart';
import 'package:markdownnotepad/models/note_simple.dart';
import 'package:markdownnotepad/models/notetag_simple.dart';

part 'user_me_response_model.g.dart';

@JsonSerializable()
class UserMeResponseModel {
  final String id;
  final String username;
  final String email;
  final String? bio;
  final String? name;
  final String? surname;
  final DateTime createdAt;
  final DateTime updatedAt;
  @JsonKey(toJson: NoteSimple.notesToJson, fromJson: NoteSimple.notesFromJson)
  final List<NoteSimple> notes;
  @JsonKey(
      toJson: NoteTagSimple.noteTagsToJson,
      fromJson: NoteTagSimple.noteTagsFromJson)
  final List<NoteTagSimple> tags;
  @JsonKey(
      toJson: CatalogSimple.catalogsToJson,
      fromJson: CatalogSimple.catalogsFromJson)
  final List<CatalogSimple> catalogs;

  UserMeResponseModel({
    required this.id,
    required this.username,
    required this.email,
    this.bio,
    this.name,
    this.surname,
    required this.createdAt,
    required this.updatedAt,
    required this.notes,
    required this.tags,
    required this.catalogs,
  });

  factory UserMeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserMeResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserMeResponseModelToJson(this);
}

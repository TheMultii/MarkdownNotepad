import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/catalog.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/models/notetag.dart';

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
  @JsonKey(toJson: Note.notesToJson, fromJson: Note.notesFromJson)
  final List<Note> notes;
  @JsonKey(toJson: NoteTag.noteTagsToJson, fromJson: NoteTag.noteTagsFromJson)
  final List<NoteTag> tags;
  @JsonKey(toJson: Catalog.catalogsToJson, fromJson: Catalog.catalogsFromJson)
  final List<Catalog> catalogs;

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

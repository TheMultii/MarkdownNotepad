import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/catalog.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/models/notetag.dart';

part 'user.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String email;
  @HiveField(3)
  String? bio;
  @HiveField(4)
  String name;
  @HiveField(5)
  String surname;
  @HiveField(6)
  String createdAt;
  @HiveField(7)
  String updatedAt;
  @HiveField(8)
  @JsonKey(toJson: Note.notesToJson, fromJson: Note.notesFromJson)
  List<Note>? notes;
  @HiveField(9)
  @JsonKey(toJson: NoteTag.noteTagsToJson, fromJson: NoteTag.noteTagsFromJson)
  List<NoteTag>? tags;
  @HiveField(10)
  @JsonKey(toJson: Catalog.catalogsToJson, fromJson: Catalog.catalogsFromJson)
  List<Catalog>? catalogs;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.bio,
    required this.name,
    required this.surname,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.tags,
    this.catalogs,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  static List<User> usersFromJson(List<dynamic> json) {
    List<User> users = [];
    for (var element in json) {
      users.add(User.fromJson(element));
    }
    return users;
  }

  static List<Map<String, dynamic>> usersToJson(List<User>? users) {
    if (users == null) return [];
    List<Map<String, dynamic>> json = [];
    for (var user in users) {
      json.add(user.toJson());
    }
    return json;
  }

  static User? userFromJson(Map<String, dynamic>? json) =>
      json != null ? User.fromJson(json) : null;

  static Map<String, dynamic>? userToJson(User? user) => user?.toJson();
}

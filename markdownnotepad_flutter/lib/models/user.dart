import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/models/catalog.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/models/notetag.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String email;
  @HiveField(3)
  String name;
  @HiveField(4)
  String surname;
  @HiveField(5)
  String createdAt;
  @HiveField(6)
  String updatedAt;
  @HiveField(7)
  List<Note>? notes;
  @HiveField(8)
  List<NoteTag>? tags;
  @HiveField(9)
  List<Catalog>? catalogs;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.surname,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.catalogs,
  });
}

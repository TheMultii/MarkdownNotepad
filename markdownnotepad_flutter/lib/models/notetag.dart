import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/models/user.dart';

part 'notetag.g.dart';

@HiveType(typeId: 4)
class NoteTag extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String color;
  @HiveField(3)
  String createdAt;
  @HiveField(4)
  String updatedAt;
  @HiveField(5)
  User owner;
  @HiveField(6)
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
}

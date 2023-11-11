import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/models/catalog.dart';
import 'package:markdownnotepad/models/notetag.dart';
import 'package:markdownnotepad/models/user.dart';

part 'note.g.dart';

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
  String createdAt;
  @HiveField(5)
  String updatedAt;
  @HiveField(6)
  String? localNotePassword;
  @HiveField(7)
  List<NoteTag>? tags;
  @HiveField(8)
  User? user;
  @HiveField(9)
  Catalog? folder;

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
}

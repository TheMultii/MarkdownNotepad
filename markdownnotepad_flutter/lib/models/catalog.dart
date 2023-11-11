import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/models/user.dart';

part 'catalog.g.dart';

@HiveType(typeId: 3)
class Catalog extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String createdAt;
  @HiveField(3)
  String updatedAt;
  @HiveField(4)
  List<Note>? notes;
  @HiveField(5)
  User? owner;

  Catalog({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.owner,
  });
}

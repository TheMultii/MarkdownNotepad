import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/enums/extension_status.dart';

part 'extension.g.dart';

@HiveType(typeId: 9)
class MDNExtension extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String version;
  @HiveField(2)
  final String author;
  @HiveField(3)
  final ExtensionStatus status;
  @HiveField(4)
  final String content;

  MDNExtension({
    required this.title,
    required this.version,
    required this.author,
    required this.status,
    required this.content,
  });
}

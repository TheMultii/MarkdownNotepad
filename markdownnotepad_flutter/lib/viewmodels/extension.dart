import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/enums/extension_status.dart';

part 'extension.g.dart';

@JsonSerializable()
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
  final String activator;
  @HiveField(5)
  final String content;

  MDNExtension({
    required this.title,
    required this.version,
    required this.author,
    required this.status,
    required this.activator,
    required this.content,
  });

  factory MDNExtension.fromJson(Map<String, dynamic> json) =>
      _$MDNExtensionFromJson(json);
  Map<String, dynamic> toJson() => _$MDNExtensionToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'load_extension.g.dart';

@JsonSerializable()
class MDNLoadExtension {
  final String title;
  final String version;
  final String author;
  final String activator;
  final String content;

  MDNLoadExtension({
    required this.title,
    required this.version,
    required this.author,
    required this.activator,
    required this.content,
  });

  factory MDNLoadExtension.fromJson(Map<String, dynamic> json) =>
      _$MDNLoadExtensionFromJson(json);
  Map<String, dynamic> toJson() => _$MDNLoadExtensionToJson(this);
}

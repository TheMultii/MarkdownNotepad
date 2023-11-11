import 'package:json_annotation/json_annotation.dart';

part 'post_note_body_model.g.dart';

@JsonSerializable()
class PostNoteBodyModel {
  final String title;
  final String content;
  final String? folderId;
  final List<String>? tags;

  PostNoteBodyModel({
    required this.title,
    required this.content,
    this.folderId,
    this.tags,
  });

  factory PostNoteBodyModel.fromJson(Map<String, dynamic> json) =>
      _$PostNoteBodyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostNoteBodyModelToJson(this);
}

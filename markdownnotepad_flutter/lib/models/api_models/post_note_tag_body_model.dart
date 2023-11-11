import 'package:json_annotation/json_annotation.dart';

part 'post_note_tag_body_model.g.dart';

@JsonSerializable()
class PostNoteTagBodyModel {
  final String title;
  final String color;

  PostNoteTagBodyModel({
    required this.title,
    required this.color,
  });

  factory PostNoteTagBodyModel.fromJson(Map<String, dynamic> json) =>
      _$PostNoteTagBodyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostNoteTagBodyModelToJson(this);
}

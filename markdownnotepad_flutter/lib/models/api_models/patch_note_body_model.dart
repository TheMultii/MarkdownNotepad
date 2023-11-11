import 'package:json_annotation/json_annotation.dart';

part 'patch_note_body_model.g.dart';

@JsonSerializable()
class PatchNoteBodyModel {
  final String? title;
  final String? content;
  final String? folderId;
  final List<String>? tags;

  PatchNoteBodyModel({
    this.title,
    this.content,
    this.folderId,
    this.tags,
  });

  factory PatchNoteBodyModel.fromJson(Map<String, dynamic> json) =>
      _$PatchNoteBodyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PatchNoteBodyModelToJson(this);
}

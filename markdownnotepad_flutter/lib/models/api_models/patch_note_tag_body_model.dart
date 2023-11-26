import 'package:json_annotation/json_annotation.dart';

part 'patch_note_tag_body_model.g.dart';

@JsonSerializable()
class PatchNoteTagBodyModel {
  String? title;
  String? color;

  PatchNoteTagBodyModel({
    this.title,
    this.color,
  });

  factory PatchNoteTagBodyModel.fromJson(Map<String, dynamic> json) =>
      _$PatchNoteTagBodyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PatchNoteTagBodyModelToJson(this);
}

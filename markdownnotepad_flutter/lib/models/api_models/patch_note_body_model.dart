import 'package:json_annotation/json_annotation.dart';

part 'patch_note_body_model.g.dart';

@JsonSerializable()
class PatchNoteBodyModel {
  final String? title;
  final String? color;

  PatchNoteBodyModel({
    this.title,
    this.color,
  });

  factory PatchNoteBodyModel.fromJson(Map<String, dynamic> json) =>
      _$PatchNoteBodyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PatchNoteBodyModelToJson(this);
}

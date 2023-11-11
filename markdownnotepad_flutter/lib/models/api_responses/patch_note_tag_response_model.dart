import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/notetag.dart';

part 'patch_note_tag_response_model.g.dart';

@JsonSerializable()
class PatchNoteTagResponseModel {
  String message;
  @JsonKey(toJson: NoteTag.noteTagToJson, fromJson: NoteTag.noteTagFromJson)
  NoteTag noteTag;

  PatchNoteTagResponseModel({
    required this.message,
    required this.noteTag,
  });

  factory PatchNoteTagResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PatchNoteTagResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PatchNoteTagResponseModelToJson(this);
}

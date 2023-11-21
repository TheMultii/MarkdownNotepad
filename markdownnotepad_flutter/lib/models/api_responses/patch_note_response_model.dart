import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/note_simple.dart';

part 'patch_note_response_model.g.dart';

@JsonSerializable()
class PatchNoteResponseModel {
  String message;
  @JsonKey(toJson: NoteSimple.noteToJson, fromJson: NoteSimple.noteFromJson)
  NoteSimple note;

  PatchNoteResponseModel({
    required this.message,
    required this.note,
  });

  factory PatchNoteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PatchNoteResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PatchNoteResponseModelToJson(this);
}

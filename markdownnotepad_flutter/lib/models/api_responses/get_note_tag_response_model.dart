import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/notetag.dart';

part 'get_note_tag_response_model.g.dart';

@JsonSerializable()
class GetNoteTagResponseModel {
  @JsonKey(toJson: NoteTag.noteTagToJson, fromJson: NoteTag.noteTagFromJson)
  NoteTag noteTag;

  GetNoteTagResponseModel({
    required this.noteTag,
  });

  factory GetNoteTagResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetNoteTagResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetNoteTagResponseModelToJson(this);
}

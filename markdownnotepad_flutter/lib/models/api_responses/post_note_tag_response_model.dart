import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/notetag.dart';

part 'post_note_tag_response_model.g.dart';

@JsonSerializable()
class PostNoteTagResponseModel {
  String message;
  @JsonKey(toJson: NoteTag.noteTagToJson, fromJson: NoteTag.noteTagFromJson)
  NoteTag noteTag;

  PostNoteTagResponseModel({
    required this.message,
    required this.noteTag,
  });

  factory PostNoteTagResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostNoteTagResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostNoteTagResponseModelToJson(this);
}

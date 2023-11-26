import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/notetag_simple.dart';

part 'post_note_tag_response_model.g.dart';

@JsonSerializable()
class PostNoteTagResponseModel {
  String message;
  @JsonKey(
    toJson: NoteTagSimple.noteTagToJson,
    fromJson: NoteTagSimple.noteTagFromJson,
  )
  NoteTagSimple noteTag;

  PostNoteTagResponseModel({
    required this.message,
    required this.noteTag,
  });

  factory PostNoteTagResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostNoteTagResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostNoteTagResponseModelToJson(this);
}

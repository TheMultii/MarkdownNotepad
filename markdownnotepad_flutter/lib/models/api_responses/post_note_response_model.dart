import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/note_simple.dart';

part 'post_note_response_model.g.dart';

@JsonSerializable()
class PostNoteResponseModel {
  String message;
  @JsonKey(toJson: NoteSimple.noteToJson, fromJson: NoteSimple.noteFromJson)
  NoteSimple note;

  PostNoteResponseModel({
    required this.message,
    required this.note,
  });

  factory PostNoteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostNoteResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostNoteResponseModelToJson(this);
}

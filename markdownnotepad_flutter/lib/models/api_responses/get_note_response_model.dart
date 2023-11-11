import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/note.dart';

part 'get_note_response_model.g.dart';

@JsonSerializable()
class GetNoteResponseModel {
  @JsonKey(toJson: Note.noteToJson, fromJson: Note.noteFromJson)
  Note note;

  GetNoteResponseModel({
    required this.note,
  });

  factory GetNoteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetNoteResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetNoteResponseModelToJson(this);
}

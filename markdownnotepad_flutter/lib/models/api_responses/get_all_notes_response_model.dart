import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/note.dart';

part 'get_all_notes_response_model.g.dart';

@JsonSerializable()
class GetAllNotesResponseModel {
  @JsonKey(toJson: Note.notesToJson, fromJson: Note.notesFromJson)
  List<Note> notes;

  GetAllNotesResponseModel({
    required this.notes,
  });

  factory GetAllNotesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetAllNotesResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetAllNotesResponseModelToJson(this);
}

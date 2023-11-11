import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/notetag.dart';

part 'get_all_note_tags_response_model.g.dart';

@JsonSerializable()
class GetAllNoteTagsResponseModel {
  @JsonKey(toJson: NoteTag.noteTagsToJson, fromJson: NoteTag.noteTagsFromJson)
  List<NoteTag> noteTags;

  GetAllNoteTagsResponseModel({
    required this.noteTags,
  });

  factory GetAllNoteTagsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetAllNoteTagsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetAllNoteTagsResponseModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'miscellaneous_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MiscellaneousResponseModel {
  String name;
  String time;

  MiscellaneousResponseModel({
    required this.name,
    required this.time,
  });

  factory MiscellaneousResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MiscellaneousResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$MiscellaneousResponseModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'message_failure_model.g.dart';

@JsonSerializable()
class MessageFailureModel {
  final String message;

  MessageFailureModel({
    required this.message,
  });

  factory MessageFailureModel.fromJson(Map<String, dynamic> json) =>
      _$MessageFailureModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageFailureModelToJson(this);
}

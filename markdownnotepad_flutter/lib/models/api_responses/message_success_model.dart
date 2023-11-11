import 'package:json_annotation/json_annotation.dart';

part 'message_success_model.g.dart';

@JsonSerializable()
class MessageSuccessModel {
  final String message;

  MessageSuccessModel({
    required this.message,
  });

  factory MessageSuccessModel.fromJson(Map<String, dynamic> json) =>
      _$MessageSuccessModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageSuccessModelToJson(this);
}

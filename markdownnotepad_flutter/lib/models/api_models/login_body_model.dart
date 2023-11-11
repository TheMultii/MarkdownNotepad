import 'package:json_annotation/json_annotation.dart';

part 'login_body_model.g.dart';

@JsonSerializable()
class LoginBodyModel {
  final String username;
  final String password;

  LoginBodyModel({
    required this.username,
    required this.password,
  });

  factory LoginBodyModel.fromJson(Map<String, dynamic> json) =>
      _$LoginBodyModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginBodyModelToJson(this);
}

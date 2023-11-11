import 'package:json_annotation/json_annotation.dart';

part 'patch_user_body_model.g.dart';

@JsonSerializable()
class PatchUserBodyModel {
  final String? username;
  final String? email;
  final String? name;
  final String? surname;
  final String? password;

  PatchUserBodyModel({
    this.username,
    this.email,
    this.name,
    this.surname,
    this.password,
  });

  factory PatchUserBodyModel.fromJson(Map<String, dynamic> json) =>
      _$PatchUserBodyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PatchUserBodyModelToJson(this);
}

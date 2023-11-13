import 'package:json_annotation/json_annotation.dart';

part 'patch_user_body_model.g.dart';

@JsonSerializable()
class PatchUserBodyModel {
  String? username;
  String? email;
  String? name;
  String? bio;
  String? surname;
  String? password;

  PatchUserBodyModel({
    this.username,
    this.email,
    this.name,
    this.bio,
    this.surname,
    this.password,
  });

  factory PatchUserBodyModel.fromJson(Map<String, dynamic> json) =>
      _$PatchUserBodyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PatchUserBodyModelToJson(this);
}

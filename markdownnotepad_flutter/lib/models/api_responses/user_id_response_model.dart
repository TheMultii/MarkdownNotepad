import 'package:json_annotation/json_annotation.dart';

part 'user_id_response_model.g.dart';

@JsonSerializable()
class UserIdResponseModel {
  final String id;
  final String username;
  final String email;
  final String? bio;
  final String? name;
  final String? surname;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserIdResponseModel({
    required this.id,
    required this.username,
    required this.email,
    this.bio,
    required this.name,
    required this.surname,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserIdResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserIdResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserIdResponseModelToJson(this);
}

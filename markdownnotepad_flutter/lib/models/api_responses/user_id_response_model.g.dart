// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_id_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserIdResponseModel _$UserIdResponseModelFromJson(Map<String, dynamic> json) =>
    UserIdResponseModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserIdResponseModelToJson(
        UserIdResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'name': instance.name,
      'surname': instance.surname,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

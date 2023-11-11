// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_user_body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchUserBodyModel _$PatchUserBodyModelFromJson(Map<String, dynamic> json) =>
    PatchUserBodyModel(
      username: json['username'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$PatchUserBodyModelToJson(PatchUserBodyModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'name': instance.name,
      'surname': instance.surname,
      'password': instance.password,
    };

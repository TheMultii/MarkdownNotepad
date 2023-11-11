// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterBodyModel _$RegisterBodyModelFromJson(Map<String, dynamic> json) =>
    RegisterBodyModel(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterBodyModelToJson(RegisterBodyModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
    };

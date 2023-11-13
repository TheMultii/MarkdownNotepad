// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_me_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMeResponseModel _$UserMeResponseModelFromJson(Map<String, dynamic> json) =>
    UserMeResponseModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      notes: NoteSimple.notesFromJson(json['notes'] as List),
      tags: NoteTagSimple.noteTagsFromJson(json['tags'] as List),
      catalogs: Catalog.catalogsFromJson(json['catalogs'] as List),
    );

Map<String, dynamic> _$UserMeResponseModelToJson(
        UserMeResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'bio': instance.bio,
      'name': instance.name,
      'surname': instance.surname,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'notes': NoteSimple.notesToJson(instance.notes),
      'tags': NoteTagSimple.noteTagsToJson(instance.tags),
      'catalogs': Catalog.catalogsToJson(instance.catalogs),
    };

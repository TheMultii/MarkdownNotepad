// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_extension.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MDNLoadExtension _$MDNLoadExtensionFromJson(Map<String, dynamic> json) =>
    MDNLoadExtension(
      title: json['title'] as String,
      version: json['version'] as String,
      author: json['author'] as String,
      activator: json['activator'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$MDNLoadExtensionToJson(MDNLoadExtension instance) =>
    <String, dynamic>{
      'title': instance.title,
      'version': instance.version,
      'author': instance.author,
      'activator': instance.activator,
      'content': instance.content,
    };

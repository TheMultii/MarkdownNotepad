// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connected_live_share_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectedLiveShareUser _$ConnectedLiveShareUserFromJson(
        Map<String, dynamic> json) =>
    ConnectedLiveShareUser(
      id: json['id'] as String,
      username: json['username'] as String,
      currentLine: json['currentLine'] as int?,
    );

Map<String, dynamic> _$ConnectedLiveShareUserToJson(
        ConnectedLiveShareUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'currentLine': instance.currentLine,
    };

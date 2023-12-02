import 'package:json_annotation/json_annotation.dart';

part 'connected_live_share_user.g.dart';

@JsonSerializable()
class ConnectedLiveShareUser {
  String id;
  String username;
  int? currentLine;

  ConnectedLiveShareUser({
    required this.id,
    required this.username,
    required this.currentLine,
  });

  factory ConnectedLiveShareUser.fromJson(Map<String, dynamic> json) =>
      _$ConnectedLiveShareUserFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectedLiveShareUserToJson(this);
}

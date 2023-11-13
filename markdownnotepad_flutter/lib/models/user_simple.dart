import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_simple.g.dart';

@JsonSerializable()
@HiveType(typeId: 8)
class UserSimple extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String email;
  @HiveField(3)
  String? bio;

  UserSimple({
    required this.id,
    required this.username,
    required this.email,
    this.bio,
  });

  factory UserSimple.fromJson(Map<String, dynamic> json) =>
      _$UserSimpleFromJson(json);
  Map<String, dynamic> toJson() => _$UserSimpleToJson(this);

  static List<UserSimple> usersFromJson(List<dynamic> json) {
    List<UserSimple> users = [];
    for (var element in json) {
      users.add(UserSimple.fromJson(element));
    }
    return users;
  }

  static List<Map<String, dynamic>> usersToJson(List<UserSimple>? users) {
    if (users == null) return [];
    List<Map<String, dynamic>> json = [];
    for (var user in users) {
      json.add(user.toJson());
    }
    return json;
  }

  static UserSimple? userFromJson(Map<String, dynamic>? json) =>
      json != null ? UserSimple.fromJson(json) : null;

  static Map<String, dynamic>? userToJson(UserSimple? user) => user?.toJson();
}

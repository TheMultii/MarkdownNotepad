import 'package:hive/hive.dart';
import 'package:markdownnotepad/models/user.dart';

part 'logged_in_user.g.dart';

@HiveType(typeId: 5)
class LoggedInUser extends HiveObject {
  @HiveField(0)
  User user;
  @HiveField(1)
  String accessToken;
  @HiveField(2)
  DateTime timeOfLogin;
  @HiveField(3)
  DateTime tokenExpiration;

  LoggedInUser({
    required this.user,
    required this.accessToken,
    required this.timeOfLogin,
    required this.tokenExpiration,
  });
}

import 'package:hive/hive.dart';

part 'server_settings.g.dart';

@HiveType(typeId: 0)
class ServerSettings extends HiveObject {
  @HiveField(0)
  String ipAddress;
  @HiveField(1)
  int port;

  ServerSettings({
    required this.ipAddress,
    required this.port,
  });
}

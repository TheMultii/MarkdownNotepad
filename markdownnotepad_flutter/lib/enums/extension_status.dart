import 'package:hive_flutter/hive_flutter.dart';

part 'extension_status.g.dart';

@HiveType(typeId: 11)
enum ExtensionStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  inactive,
  @HiveField(2)
  invalid,
}

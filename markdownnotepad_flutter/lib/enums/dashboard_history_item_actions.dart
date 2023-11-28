import 'package:hive_flutter/hive_flutter.dart';

part 'dashboard_history_item_actions.g.dart';

@HiveType(typeId: 14)
enum DashboardHistoryItemActions {
  @HiveField(0)
  createdNote,
  @HiveField(1)
  editedNote,
  @HiveField(2)
  deletedNote,
  @HiveField(3)
  addedTag,
  @HiveField(4)
  removedTag,
  @HiveField(5)
  unknown,
}

import 'package:markdownnotepad/models/user.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm.dart';
import 'package:collection/collection.dart';

EventLogVM fillEventLogInfo(EventLogVM eventLog, User user) {
  eventLog.tagsTitles = eventLog.tagsId
      .map((tagId) =>
          user.tags?.firstWhereOrNull((tag) => tag.id == tagId)?.title ?? "")
      .toList();

  eventLog.tagsColors = eventLog.tagsId
      .map((tagId) =>
          user.tags?.firstWhereOrNull((tag) => tag.id == tagId)?.color ??
          "#FF0000")
      .toList();

  eventLog.catalogTitle = user.catalogs
      ?.firstWhereOrNull((catalog) => catalog.id == eventLog.catalogId)
      ?.title;

  final note =
      user.notes?.firstWhereOrNull((note) => note.id == eventLog.noteId);
  eventLog.noteTitle = note?.title;
  eventLog.exists = note != null;

  return eventLog;
}

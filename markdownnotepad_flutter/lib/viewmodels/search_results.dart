import 'package:markdownnotepad/viewmodels/search_result.dart';

class SearchResults {
  SearchResult? actionResult;
  SearchResult? liveShareNote;
  List<SearchResult> notes;
  List<SearchResult> tags;
  List<SearchResult> catalogs;
  bool get isEmpty =>
      notes.isEmpty &&
      tags.isEmpty &&
      catalogs.isEmpty &&
      actionResult == null &&
      liveShareNote == null;

  SearchResults({
    this.actionResult,
    this.liveShareNote,
    this.notes = const [],
    this.tags = const [],
    this.catalogs = const [],
  });
}

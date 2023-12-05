import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:markdownnotepad/components/search_bar_item.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/helpers/navigation_helper.dart';
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/models/api_responses/get_note_response_model.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:markdownnotepad/viewmodels/search_result.dart';
import 'package:markdownnotepad/viewmodels/search_results.dart';
import 'package:provider/provider.dart';

class MDNSearchBarWidget extends StatefulWidget {
  const MDNSearchBarWidget({super.key});

  @override
  State<MDNSearchBarWidget> createState() => _MDNSearchBarWidgetState();
}

class _MDNSearchBarWidgetState extends State<MDNSearchBarWidget> {
  double widgetTop = 10.0;
  String textValue = "";

  bool isSearching = false;
  SearchResults searchResults = SearchResults();

  late String authorizationString;
  LoggedInUser? get loggedInUser =>
      context.read<CurrentLoggedInUserProvider>().currentUser;
  MDNApiService? get apiService =>
      context.read<ApiServiceProvider>().apiService;

  @override
  void initState() {
    super.initState();

    authorizationString = "Bearer ${loggedInUser?.accessToken}";
  }

  final List<Map<String, String>> searchActions = [
    {"destination": "/dashboard/", "title": "Dashboard"},
    {"destination": "/miscellaneous/account", "title": "Konto"},
    {"destination": "/miscellaneous/account", "title": "Account"},
    {"destination": "/miscellaneous/extensions", "title": "Rozszerzenia"},
    {"destination": "/miscellaneous/extensions", "title": "Extensions"},
    {"destination": "", "title": "Wyloguj"},
    {"destination": "", "title": "Logout"}
  ];

  void dismiss() {
    setState(() {
      widgetTop = -1000;
    });
    Timer(100.ms, () {
      if (!mounted) return;
      Navigator.of(context).pop();
    });
  }

  void search() async {
    setState(() => isSearching = true);

    searchResults = SearchResults();

    if (textValue.isNotEmpty) {
      await _searchLiveShareNote();

      if (textValue.length > 2) {
        _searchActionResults();
      }

      _searchItems(loggedInUser!.user.notes!, SearchResultType.note);
      _searchItems(loggedInUser!.user.tags!, SearchResultType.tag);
      _searchItems(loggedInUser!.user.catalogs!, SearchResultType.catalog);
    }

    setState(() => isSearching = false);
  }

  Future<void> _searchLiveShareNote() async {
    try {
      final String splittedSlash = textValue.split("/").last;
      if (MDNValidator.validateUUID(splittedSlash) == null &&
          !loggedInUser!.user.notes!
              .any((element) => element.id == splittedSlash) &&
          apiService != null) {
        final GetNoteResponseModel? liveShareNote =
            await apiService!.getNote(splittedSlash, authorizationString);

        if (liveShareNote != null) {
          searchResults.liveShareNote = SearchResult(
            id: splittedSlash,
            title: liveShareNote.note.title,
            type: SearchResultType.note,
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _searchActionResults() {
    for (final Map<String, String> action in searchActions) {
      if (action['title']?.toLowerCase().contains(textValue.toLowerCase()) ??
          false) {
        searchResults.actionResult = SearchResult(
          id: action['destination']!,
          title: action["title"]!,
          type: SearchResultType.other,
          onTap: action["title"]! == "Wyloguj" || action["title"]! == "Logout"
              ? () => context.read<CurrentLoggedInUserProvider>().logout()
              : null,
        );
        break;
      }
    }
  }

  void _searchItems(List<dynamic> items, SearchResultType resultType) {
    searchResults.notes = items
        .where((element) =>
            element.title.toLowerCase().contains(textValue.toLowerCase()) ||
            (element.id.toLowerCase().contains(textValue.toLowerCase()) &&
                textValue.length == 36))
        .map(
          (e) => SearchResult(
            id: e.id,
            title: e.title,
            type: resultType,
          ),
        )
        .toList();
  }

  void onTapItem(SearchResult searchResult) {
    dismiss();
    String destination = "";

    switch (searchResult.type) {
      case SearchResultType.note:
        destination = "/editor/${searchResult.id}";
        break;
      case SearchResultType.catalog:
        destination = "/dashboard/directory/${searchResult.id}";
        break;
      case SearchResultType.tag:
        break;
      case SearchResultType.other:
        destination = searchResult.id;
        break;
    }

    if (destination.isEmpty) return;

    NavigationHelper.navigateToPage(
      context,
      destination,
    );
  }

  @override
  Widget build(BuildContext context) {
    double margin = MediaQuery.of(context).size.width * (.45 / 2);
    if (Responsive.isMobile(context)) {
      margin = MediaQuery.of(context).size.width * (.15 / 2);
    }

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (value) {
        if (value.isKeyPressed(LogicalKeyboardKey.escape)) {
          return dismiss();
        }
      },
      child: Stack(
        children: [
          GestureDetector(
            child: SizedBox.expand(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            onTap: () => dismiss(),
          ),
          AnimatedPositioned(
            duration: 150.ms,
            top: widgetTop,
            left: margin,
            right: margin,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 2.5,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .extension<MarkdownNotepadTheme>()
                      ?.cardColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: TextField(
                                  autofocus: true,
                                  focusNode: FocusNode()..requestFocus(),
                                  onEditingComplete: () => search(),
                                  onChanged: (value) {
                                    setState(() => textValue = value);
                                    search();
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Wyszukaj...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (textValue.isNotEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Theme.of(context)
                                .extension<MarkdownNotepadTheme>()
                                ?.text
                                ?.withOpacity(.5),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              top: 6,
                              bottom: 8,
                              left: 10,
                              right: 10,
                            ),
                            child: isSearching
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3.0,
                                    ),
                                  )
                                : searchResults.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Brak wyników',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (searchResults.actionResult !=
                                              null)
                                            SearchBarItem(
                                              elementID: searchResults
                                                  .actionResult!.id,
                                              text: searchResults
                                                  .actionResult!.title,
                                              isLast: true,
                                              onTap: () {
                                                if (searchResults
                                                        .actionResult!.onTap !=
                                                    null) {
                                                  searchResults
                                                      .actionResult!.onTap!();
                                                  return;
                                                }
                                                onTapItem(searchResults
                                                    .actionResult!);
                                              },
                                            ),
                                          if (searchResults.liveShareNote !=
                                              null) ...[
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 4.0,
                                              ),
                                              child: Text(
                                                'LiveShare',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SearchBarItem(
                                              elementID: searchResults
                                                  .liveShareNote!.id,
                                              text: searchResults
                                                  .liveShareNote!.title,
                                              isLast: true,
                                              onTap: () {
                                                if (searchResults
                                                        .liveShareNote!.onTap !=
                                                    null) {
                                                  searchResults
                                                      .liveShareNote!.onTap!();
                                                  return;
                                                }
                                                onTapItem(searchResults
                                                    .liveShareNote!);
                                              },
                                            ),
                                          ],
                                          if (searchResults
                                              .notes.isNotEmpty) ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 4.0,
                                              ),
                                              child: Text(
                                                'Notatki (${searchResults.notes.length})',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            ...searchResults.notes
                                                .getRange(
                                                    0,
                                                    searchResults.notes.length >
                                                            2
                                                        ? 2
                                                        : searchResults
                                                            .notes.length)
                                                .toList()
                                                .asMap()
                                                .entries
                                                .map(
                                              (entry) {
                                                final index = entry.key;
                                                final entryValue = entry.value;

                                                return SearchBarItem(
                                                  elementID: entryValue.id,
                                                  text: entryValue.title,
                                                  isLast: index ==
                                                      searchResults
                                                              .notes.length -
                                                          1,
                                                  onTap: () =>
                                                      onTapItem(entryValue),
                                                );
                                              },
                                            ),
                                          ],
                                          if (searchResults
                                              .catalogs.isNotEmpty) ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 4.0,
                                              ),
                                              child: Text(
                                                'Foldery (${searchResults.catalogs.length})',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            ...searchResults.catalogs
                                                .getRange(
                                                    0,
                                                    searchResults.catalogs
                                                                .length >
                                                            2
                                                        ? 2
                                                        : searchResults
                                                            .catalogs.length)
                                                .toList()
                                                .asMap()
                                                .entries
                                                .map(
                                              (entry) {
                                                final index = entry.key;
                                                final entryValue = entry.value;

                                                return SearchBarItem(
                                                  elementID: entryValue.id,
                                                  text: entryValue.title,
                                                  isLast: index ==
                                                      searchResults
                                                              .notes.length -
                                                          1,
                                                  onTap: () =>
                                                      onTapItem(entryValue),
                                                );
                                              },
                                            ),
                                          ],
                                        ],
                                      ),
                          ),
                        ],
                      ),
                  ],
                ),
              )
                  .animate()
                  .slideY(
                    duration: 100.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(
                    duration: 100.ms,
                    curve: Curves.easeOut,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

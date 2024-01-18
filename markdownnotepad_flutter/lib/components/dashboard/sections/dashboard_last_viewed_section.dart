import 'dart:math';

import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_history_list_item.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_last_viewed_cards.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

class DashboardLastViewedSection extends StatelessWidget {
  final LoggedInUser loggedInUser;
  final List<EventLogVM>? eventLogs;

  const DashboardLastViewedSection({
    super.key,
    required this.loggedInUser,
    required this.eventLogs,
  });

  @override
  Widget build(BuildContext context) {
    const int maxEventLogs = 5;
    final List<Note> notesSorted =
        loggedInUser.user.notes == null ? [] : loggedInUser.user.notes!
          ..sort(
            (a, b) => b.updatedAt.compareTo(a.updatedAt),
          );

    final bool isEmptySection =
        (loggedInUser.user.notes == null || loggedInUser.user.notes!.isEmpty) &&
            (eventLogs == null || eventLogs!.isEmpty);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEmptySection)
          const SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Brak ostatnio wyświetlanych notatek.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Nic nie szkodzi, możesz zacząć od dodania nowej notatki.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        if (!isEmptySection)
          DashboardLastViewedCards(
            items: [
              ...notesSorted
                  .getRange(0, notesSorted.length >= 3 ? 3 : notesSorted.length)
                  .map(
                    (note) => {
                      "id": note.id,
                      "title": note.title,
                      "subtitle":
                          note.content.replaceAll("\n", " ").trim().isEmpty
                              ? ""
                              : note.content.replaceAll("\n", " ").length > 50
                                  ? note.content
                                      .replaceAll("\n", " ")
                                      .trim()
                                      .substring(0, 50)
                                  : note.content.replaceAll("\n", "").trim(),
                      "editDate": note.updatedAt,
                      "isLocalImage": true,
                      "backgroundImage":
                          "assets/images/img-${Random().nextInt(10) + 1}.jpeg",
                    },
                  ),
              ...(notesSorted.length < 3
                  ? List.generate(
                      3 - notesSorted.length,
                      (index) => {
                        "id": 0,
                        "title": "",
                        "subtitle": "",
                        "editDate": DateTime.now(),
                        "isLocalImage": false,
                        "opacity": .15,
                        "disabled": true,
                        "backgroundImage": "",
                      },
                    )
                  : []),
            ],
          ),
        const SizedBox(height: 24.0),
        Stack(
          children: [
            Positioned(
              top: 0,
              bottom: Responsive.isMobile(context) ? 80 : 50,
              left: 11.5,
              child: Container(
                width: 2,
                color: const Color.fromARGB(255, 28, 28, 28),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: eventLogs
                      ?.take(maxEventLogs)
                      .map(
                        (entry) => DashboardHistoryListItem(
                          userName: loggedInUser.user.name.isNotEmpty
                              ? "${loggedInUser.user.name} ${loggedInUser.user.surname}"
                              : loggedInUser.user.username,
                          actionDateTime: entry.createdAt,
                          note: {
                            "id": entry.noteId,
                            "title": entry.noteTitle ?? "Nieznana notatka",
                            "exists": entry.exists,
                          },
                          action: entry.action,
                          tags: entry.tagsId.asMap().entries.map(
                            (e) {
                              final int id = e.key;
                              return {
                                "title": entry.tagsTitles[id],
                                "color": entry.tagsColors[id],
                              };
                            },
                          ).toList(),
                        ),
                      )
                      .toList() ??
                  [
                    const Text("Brak historii zdarzeń"),
                  ],
            ),
          ],
        ),
      ],
    );
  }
}

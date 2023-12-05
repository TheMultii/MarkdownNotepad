import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_history_list_item.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_last_viewed_cards.dart';
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    "isLocalImage": false,
                    "backgroundImage":
                        "https://api.mganczarczyk.pl/tairiku/random/streetmoe?safety=true&seed=${note.id}",
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
              bottom: 50,
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

import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_history_list_item.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_last_viewed_cards.dart';
import 'package:markdownnotepad/enums/dashboard_history_item_actions.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

class DashboardLastViewedSection extends StatefulWidget {
  final LoggedInUser loggedInUser;

  const DashboardLastViewedSection({
    super.key,
    required this.loggedInUser,
  });

  @override
  State<DashboardLastViewedSection> createState() =>
      _DashboardLastViewedSectionState();
}

class _DashboardLastViewedSectionState
    extends State<DashboardLastViewedSection> {
  @override
  Widget build(BuildContext context) {
    final List<Note> notesSorted = widget.loggedInUser.user.notes == null
        ? []
        : widget.loggedInUser.user.notes!
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
              children: [
                DashboardHistoryListItem(
                  isLast: false,
                  userName: widget.loggedInUser.user.name.isNotEmpty
                      ? "${widget.loggedInUser.user.name} ${widget.loggedInUser.user.surname}"
                      : widget.loggedInUser.user.username,
                  actionDateTime: DateTime.now(),
                  note: const {
                    "id": 1,
                    "title": "Sample title",
                  },
                  action: DashboardHistoryItemActions.editedNote,
                ),
                DashboardHistoryListItem(
                  isLast: false,
                  userName: widget.loggedInUser.user.name.isNotEmpty
                      ? "${widget.loggedInUser.user.name} ${widget.loggedInUser.user.surname}"
                      : widget.loggedInUser.user.username,
                  actionDateTime: DateTime.now(),
                  note: const {
                    "id": 1,
                    "title": "Sample title",
                  },
                  action: DashboardHistoryItemActions.addedTag,
                  tags: const ["TAG 1"],
                ),
                DashboardHistoryListItem(
                  isLast: false,
                  userName: widget.loggedInUser.user.name.isNotEmpty
                      ? "${widget.loggedInUser.user.name} ${widget.loggedInUser.user.surname}"
                      : widget.loggedInUser.user.username,
                  actionDateTime: DateTime.now(),
                  note: const {
                    "id": 1,
                    "title": "Sample title",
                  },
                  action: DashboardHistoryItemActions.removedTag,
                  tags: const ["TAG 2", "TAG 3"],
                ),
                DashboardHistoryListItem(
                  isLast: false,
                  userName: widget.loggedInUser.user.name.isNotEmpty
                      ? "${widget.loggedInUser.user.name} ${widget.loggedInUser.user.surname}"
                      : widget.loggedInUser.user.username,
                  actionDateTime: DateTime.now().subtract(
                    const Duration(hours: 3),
                  ),
                  note: const {
                    "id": 1,
                    "title": "Sample title",
                  },
                  action: DashboardHistoryItemActions.createdNote,
                ),
                DashboardHistoryListItem(
                  isLast: false,
                  userName: widget.loggedInUser.user.name.isNotEmpty
                      ? "${widget.loggedInUser.user.name} ${widget.loggedInUser.user.surname}"
                      : widget.loggedInUser.user.username,
                  actionDateTime: DateTime.now().subtract(
                    const Duration(days: 7),
                  ),
                  note: const {
                    "id": 1,
                    "title": "Sample title",
                  },
                  action: DashboardHistoryItemActions.deletedNote,
                ),
                DashboardHistoryListItem(
                  isLast: false,
                  userName: widget.loggedInUser.user.name.isNotEmpty
                      ? "${widget.loggedInUser.user.name} ${widget.loggedInUser.user.surname}"
                      : widget.loggedInUser.user.username,
                  actionDateTime: DateTime.now().subtract(
                    const Duration(days: 400),
                  ),
                  note: const {
                    "id": 1,
                    "title": "Sample title",
                  },
                  action: DashboardHistoryItemActions.editedNote,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

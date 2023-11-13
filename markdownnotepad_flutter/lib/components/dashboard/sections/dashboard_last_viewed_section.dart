import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_history_list_item.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_last_viewed_cards.dart';
import 'package:markdownnotepad/enums/dashboard_history_item_actions.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

class DashboardLastViewedSection extends StatelessWidget {
  final LoggedInUser loggedInUser;

  const DashboardLastViewedSection({
    super.key,
    required this.loggedInUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardLastViewedCards(
          items: [
            {
              "id": "1",
              "title": "Lorem ipsum 1",
              "subtitle": "Lorem ipsum dolor sit amet",
              "editDate": DateTime.now(),
              "isLocalImage": false,
              "backgroundImage":
                  'https://images.unsplash.com/photo-1696114865389-55096a84df67?auto=format&fit=crop&q=80&w=1887&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              "imageAlignment": const Alignment(1, -.55),
            },
            {
              "id": "2",
              "title": "Lorem ipsum 2",
              "subtitle": "Lorem ipsum dolor sit amet",
              "editDate": DateTime.now().subtract(const Duration(days: 1)),
              "isLocalImage": false,
              "backgroundImage":
                  'https://images.unsplash.com/photo-1623039497550-c4f2ccc7b875?auto=format&fit=crop&q=80&w=1887&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              "imageAlignment": const Alignment(1, -.225),
            },
            {
              "id": "3",
              "title": "Lorem ipsum 3",
              "subtitle":
                  "Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet",
              "editDate": DateTime.now().subtract(const Duration(days: 2)),
              "isLocalImage": false,
              "backgroundImage":
                  'https://images.unsplash.com/photo-1649864735667-300c31f0e5f2?auto=format&fit=crop&q=80&w=1887&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              "imageAlignment": const Alignment(1, -.2),
            }
          ],
        ),
        const SizedBox(height: 36),
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
                  userName: loggedInUser.user.name.isNotEmpty
                      ? "${loggedInUser.user.name} ${loggedInUser.user.surname}"
                      : loggedInUser.user.username,
                  actionDateTime: DateTime.now(),
                  note: const {
                    "id": 1,
                    "title": "Sample title",
                  },
                  action: DashboardHistoryItemActions.editedNote,
                ),
                DashboardHistoryListItem(
                  isLast: false,
                  userName: loggedInUser.user.name.isNotEmpty
                      ? "${loggedInUser.user.name} ${loggedInUser.user.surname}"
                      : loggedInUser.user.username,
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
                  userName: loggedInUser.user.name.isNotEmpty
                      ? "${loggedInUser.user.name} ${loggedInUser.user.surname}"
                      : loggedInUser.user.username,
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
                  userName: loggedInUser.user.name.isNotEmpty
                      ? "${loggedInUser.user.name} ${loggedInUser.user.surname}"
                      : loggedInUser.user.username,
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
                  userName: loggedInUser.user.name.isNotEmpty
                      ? "${loggedInUser.user.name} ${loggedInUser.user.surname}"
                      : loggedInUser.user.username,
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
                  userName: loggedInUser.user.name.isNotEmpty
                      ? "${loggedInUser.user.name} ${loggedInUser.user.surname}"
                      : loggedInUser.user.username,
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

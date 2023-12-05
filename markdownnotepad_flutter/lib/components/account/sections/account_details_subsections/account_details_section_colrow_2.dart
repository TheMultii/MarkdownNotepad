import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_history_list_item.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

class AccountDetailsSectionColRow2 extends StatelessWidget {
  final List<EventLogVM>? eventLogs;
  final int maxEventLogs;
  final LoggedInUser loggedInUser;

  const AccountDetailsSectionColRow2({
    super.key,
    required this.eventLogs,
    required this.maxEventLogs,
    required this.loggedInUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color.fromARGB(255, 18, 18, 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Ostatnia aktywność",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Stack(
            children: [
              Positioned(
                top: 0,
                bottom: Responsive.isMobile(context) ? 40 : 30,
                left: 11.5,
                child: Container(
                  width: 2,
                  color: const Color.fromARGB(255, 28, 28, 28),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: eventLogs
                        ?.take(maxEventLogs)
                        .map(
                          (entry) => DashboardHistoryListItem(
                            isLast: eventLogs!.take(maxEventLogs).last == entry,
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
      ),
    );
  }
}

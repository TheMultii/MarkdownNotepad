import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/account/account_details_list_item.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_history_list_item.dart';
import 'package:markdownnotepad/helpers/date_helper.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

class AccountDetailsSection extends StatelessWidget {
  final LoggedInUser loggedInUser;
  final List<EventLogVM>? eventLogs;

  const AccountDetailsSection({
    super.key,
    required this.loggedInUser,
    required this.eventLogs,
  });

  @override
  Widget build(BuildContext context) {
    const int maxEventLogs = 3;

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: const Color.fromARGB(255, 18, 18, 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Informacje o koncie",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AccountDetailsListItem(
                    title: "ID",
                    value: loggedInUser.user.id,
                    padding: const EdgeInsets.only(
                      bottom: 4.0,
                    ),
                  ),
                  AccountDetailsListItem(
                    title: "Nick",
                    value: loggedInUser.user.username,
                    padding: const EdgeInsets.only(
                      bottom: 4.0,
                    ),
                  ),
                  AccountDetailsListItem(
                    title: "Imię i nazwisko",
                    value: loggedInUser.user.name.isNotEmpty
                        ? "${loggedInUser.user.name} ${loggedInUser.user.surname}"
                        : "Brak",
                    padding: const EdgeInsets.only(
                      bottom: 4.0,
                    ),
                    isBold: loggedInUser.user.name.isNotEmpty,
                    isItalic: loggedInUser.user.name.isEmpty,
                  ),
                  AccountDetailsListItem(
                    title: "E-mail",
                    value: loggedInUser.user.email,
                    padding: const EdgeInsets.only(
                      bottom: 4.0,
                    ),
                  ),
                  AccountDetailsListItem(
                    title: "Data rejestracji",
                    value: DateHelper.getFormattedDateTime(
                      loggedInUser.user.createdAt,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 2,
            height: 1,
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: const Color.fromARGB(255, 18, 18, 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        bottom: 30,
                        left: 11.5,
                        child: Container(
                          width: 2,
                          color: const Color.fromARGB(255, 28, 28, 28),
                        ),
                      ),
                            ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

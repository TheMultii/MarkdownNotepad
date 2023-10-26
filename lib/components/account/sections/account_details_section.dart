import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/account/account_details_list_item.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_history_list_item.dart';
import 'package:markdownnotepad/enums/dashboard_history_item_actions.dart';

class AccountDetailsSection extends StatelessWidget {
  const AccountDetailsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Informacje o koncie",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  AccountDetailsListItem(
                    title: "ID",
                    value: "1100116019864948858",
                    padding: EdgeInsets.only(
                      bottom: 4.0,
                    ),
                  ),
                  AccountDetailsListItem(
                    title: "Nick",
                    value: "TheMultii",
                    padding: EdgeInsets.only(
                      bottom: 4.0,
                    ),
                  ),
                  AccountDetailsListItem(
                    title: "Imię",
                    value: "Marcel",
                    padding: EdgeInsets.only(
                      bottom: 4.0,
                    ),
                  ),
                  AccountDetailsListItem(
                    title: "Nazwisko",
                    value: "Gańczarczyk",
                    padding: EdgeInsets.only(
                      bottom: 4.0,
                    ),
                  ),
                  AccountDetailsListItem(
                    title: "E-mail",
                    value: "marcel@mganczarczyk.pl",
                    padding: EdgeInsets.only(
                      bottom: 4.0,
                    ),
                  ),
                  AccountDetailsListItem(
                    title: "Data rejestracji",
                    value: "21.10.2023",
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DashboardHistoryListItem(
                            isLast: false,
                            user: const {
                              "id": 1,
                              "name": "Marcel Gańczarczyk",
                            },
                            actionDateTime: DateTime.now(),
                            note: const {
                              "id": 1,
                              "title": "Sample title",
                            },
                            action: DashboardHistoryItemActions.addedTag,
                          ),
                          DashboardHistoryListItem(
                            isLast: false,
                            user: const {
                              "id": 1,
                              "name": "Marcel Gańczarczyk",
                            },
                            actionDateTime: DateTime.now(),
                            note: const {
                              "id": 1,
                              "title": "Sample title",
                            },
                            action: DashboardHistoryItemActions.addedTag,
                            tags: const ["TAG 1"],
                          ),
                          DashboardHistoryListItem(
                            isLast: true,
                            user: const {
                              "id": 1,
                              "name": "Marcel Gańczarczyk",
                            },
                            actionDateTime: DateTime.now().subtract(
                              const Duration(days: 7),
                            ),
                            note: const {
                              "id": 1,
                              "title": "Sample title",
                            },
                            action: DashboardHistoryItemActions.deletedNote,
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

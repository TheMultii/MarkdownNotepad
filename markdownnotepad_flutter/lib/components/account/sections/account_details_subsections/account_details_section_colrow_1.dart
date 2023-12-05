import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/account/account_details_list_item.dart';
import 'package:markdownnotepad/helpers/date_helper.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

class AccountDetailsSectionColRow1 extends StatelessWidget {
  final LoggedInUser loggedInUser;

  const AccountDetailsSectionColRow1({
    super.key,
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
    );
  }
}

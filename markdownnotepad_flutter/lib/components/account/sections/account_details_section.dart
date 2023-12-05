import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/account/sections/account_details_subsections/account_details_section_colrow_1.dart';
import 'package:markdownnotepad/components/account/sections/account_details_subsections/account_details_section_colrow_2.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
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
    final bool isMobile = Responsive.isMobile(context);

    return IntrinsicHeight(
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          isMobile
              ? AccountDetailsSectionColRow1(
                  loggedInUser: loggedInUser,
                )
              : Expanded(
                  flex: 3,
                  child: AccountDetailsSectionColRow1(
                    loggedInUser: loggedInUser,
                  ),
                ),
          SizedBox(
            width: 2,
            height: isMobile ? 16 : 1,
          ),
          isMobile
              ? AccountDetailsSectionColRow2(
                  eventLogs: eventLogs,
                  maxEventLogs: maxEventLogs,
                  loggedInUser: loggedInUser,
                )
              : Expanded(
                  flex: 7,
                  child: AccountDetailsSectionColRow2(
                    eventLogs: eventLogs,
                    maxEventLogs: maxEventLogs,
                    loggedInUser: loggedInUser,
                  ),
                ),
        ],
      ),
    );
  }
}

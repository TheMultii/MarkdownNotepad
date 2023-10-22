import 'package:flutter/material.dart';
import 'package:markdownnotepad/enums/account_tabs.dart';

class AccountHeaderMenuButton extends StatelessWidget {
  final String text;
  final AccountTabs tab;
  final AccountTabs selectedTab;
  final Function onTap;

  const AccountHeaderMenuButton({
    super.key,
    required this.text,
    required this.tab,
    required this.selectedTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.only(
        bottom: 1,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: selectedTab == tab
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 1.5,
          ),
        ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onTap(),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

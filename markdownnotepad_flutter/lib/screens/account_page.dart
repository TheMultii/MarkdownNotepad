import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/components/account/account_header_menu_button.dart';
import 'package:markdownnotepad/components/account/sections/account_delete_account_section.dart';
import 'package:markdownnotepad/components/account/sections/account_details_section.dart';
import 'package:markdownnotepad/components/account/sections/account_edit_profile_section.dart';
import 'package:markdownnotepad/components/circle_arc.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/enums/account_tabs.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:markdownnotepad/viewmodels/server_settings.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late LoggedInUser loggedInUser;
  late MDNDiscordRPC mdnDiscordRPC;
  AccountTabs selectedTab = AccountTabs.accountDetails;

  @override
  void initState() {
    super.initState();

    mdnDiscordRPC = MDNDiscordRPC();
    mdnDiscordRPC.clearPresence();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle w60style = TextStyle(
      fontSize: 14,
      color: Theme.of(context)
          .extension<MarkdownNotepadTheme>()
          ?.text!
          .withOpacity(.6),
    );
    return Consumer<CurrentLoggedInUserProvider>(
        builder: (context, notifier, child) {
      if (notifier.currentUser == null) {
        Modular.to.navigate('/auth/login');
        return const SizedBox.shrink();
      }

      final loggedInUser = notifier.currentUser!;

      return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0).copyWith(
              top: Responsive.isDesktop(context) ? 48.0 : 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipOval(
                            child: Image.network(
                              notifier.avatarUrl,
                              width: 77,
                              height: 77,
                              fit: BoxFit.cover,
                            ),
                          ),
                          CustomPaint(
                            size: const Size(80, 80),
                            painter: CircleArc(
                              size: 90,
                              strokeWidth: 4,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.2),
                              startDegree: 155.98,
                              endDegree: 155.98 + (.1302 * 360),
                            ),
                          ),
                          CustomPaint(
                            size: const Size(80, 80),
                            painter: CircleArc(
                              size: 90,
                              strokeWidth: 4,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.4),
                              startDegree: 206.86,
                              endDegree: 206.86 + (.1686 * 360),
                            ),
                          ),
                          CustomPaint(
                            size: const Size(80, 80),
                            painter: CircleArc(
                              size: 90,
                              strokeWidth: 4,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.6),
                              startDegree: 271.38,
                              endDegree: 271.38 + (.1593 * 360),
                            ),
                          ),
                          CustomPaint(
                            size: const Size(80, 80),
                            painter: CircleArc(
                              size: 90,
                              strokeWidth: 4,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.8),
                              startDegree: 332.77,
                              endDegree: 332.77 + (.1474 * 360),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loggedInUser.user.name.isNotEmpty
                                  ? "${loggedInUser.user.name} ${loggedInUser.user.surname}"
                                  : loggedInUser.user.username,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              (loggedInUser.user.bio?.isEmpty ?? true)
                                  ? loggedInUser.user.email
                                  : loggedInUser.user.bio!,
                              style: w60style,
                            ),
                            if (loggedInUser.user.bio != null &&
                                loggedInUser.user.bio!.isNotEmpty)
                              Text(
                                loggedInUser.user.email,
                                style: w60style,
                              ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => notifier.logout(),
                        borderRadius: BorderRadius.circular(4),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "Wyloguj się",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
                    top: 40.0,
                    bottom: 32.0,
                  ),
                  child: Row(
                    children: [
                      AccountHeaderMenuButton(
                        text: "Podsumowanie konta",
                        tab: AccountTabs.accountDetails,
                        selectedTab: selectedTab,
                        onTap: () => setState(
                          () => selectedTab = AccountTabs.accountDetails,
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      AccountHeaderMenuButton(
                        text: "Edytuj profil",
                        tab: AccountTabs.editProfile,
                        selectedTab: selectedTab,
                        onTap: () => setState(
                          () => selectedTab = AccountTabs.editProfile,
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      AccountHeaderMenuButton(
                        text: "Usuń konto",
                        tab: AccountTabs.deleteAccount,
                        selectedTab: selectedTab,
                        onTap: () => setState(
                          () => selectedTab = AccountTabs.deleteAccount,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selectedTab == AccountTabs.accountDetails)
                  const AccountDetailsSection()
                else if (selectedTab == AccountTabs.editProfile)
                  const AccountEditProfileSection()
                else if (selectedTab == AccountTabs.deleteAccount)
                  const AccountDeleteAccountSection(),
              ],
            ),
          ),
        ),
      );
    });
  }
}

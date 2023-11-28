import 'package:cached_network_image/cached_network_image.dart';
import 'package:cron/cron.dart';
import 'package:dio/dio.dart';
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
import 'package:markdownnotepad/enums/dashboard_history_item_actions.dart';
import 'package:markdownnotepad/helpers/fill_event_log_info.dart';
import 'package:markdownnotepad/models/api_responses/event_logs_response_model.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm_list.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late LoggedInUser? loggedInUser;
  AccountTabs selectedTab = AccountTabs.accountDetails;

  final _eventLogsBox = Hive.box<EventLogVMList>('event_logs');

  late CurrentLoggedInUserProvider loggedInUserProvider;
  late MDNApiService apiService;

  late String authorizationString;

  late Cron getEventLogsCron;
  List<EventLogVM>? oldEventLogs;
  List<EventLogVM>? eventLogs;

  @override
  void initState() {
    super.initState();

    MDNDiscordRPC().clearPresence();

    loggedInUserProvider = context.read<CurrentLoggedInUserProvider>();

    loggedInUser = loggedInUserProvider.currentUser;
    if (loggedInUser == null) {
      Modular.to.navigate("/auth/login");
    }

    apiService = context.read<ApiServiceProvider>().apiService;
    authorizationString = "Bearer ${loggedInUser?.accessToken}";

    getInitialEventLogs();
    getEventLogs().then((_) => saveEventLogs());
    getEventLogsCron = Cron()
      ..schedule(
        Schedule.parse("*/1 * * * *"),
        () async {
          await getEventLogs();
          await saveEventLogs();
        },
      );
  }

  @override
  void dispose() {
    getEventLogsCron.close();
    super.dispose();
  }

  void getInitialEventLogs() {
    try {
      final EventLogVMList? eventLogsFromBox = _eventLogsBox.get("event_logs");
      if (eventLogsFromBox != null) {
        setState(() {
          eventLogs = eventLogsFromBox.eventLogs;
          oldEventLogs = eventLogsFromBox.eventLogs;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getEventLogs() async {
    try {
      if (loggedInUser == null) return;
      final EventLogsResponseModel? resp =
          await apiService.getEventLogs(1, authorizationString);
      if (resp == null) return;

      setState(() {
        eventLogs = resp.eventLogs
            .map((eventLog) => EventLogVM.fromEventLog(eventLog))
            .where((eventLog) =>
                eventLog.action != DashboardHistoryItemActions.unknown)
            .map((element) {
          final user = loggedInUser!.user;

          return fillEventLogInfo(element, user);
        }).toList();
      });
    } on DioException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveEventLogs() async {
    if (eventLogs == null) return;
    if (oldEventLogs == null ||
        eventLogs!.length != oldEventLogs!.length ||
        eventLogs!.any((eventLog) => !oldEventLogs!.contains(eventLog))) {
      oldEventLogs = eventLogs;

      await _eventLogsBox.clear();
      _eventLogsBox.put(
        "event_logs",
        EventLogVMList(eventLogs: eventLogs),
      );
    }
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

      loggedInUser = notifier.currentUser;

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
                            child: CachedNetworkImage(
                              imageUrl: notifier.avatarUrl,
                              width: 77,
                              height: 77,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(
                                strokeWidth: 3.0,
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                              ),
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
                              loggedInUser!.user.name.isNotEmpty
                                  ? "${loggedInUser!.user.name} ${loggedInUser!.user.surname}"
                                  : loggedInUser!.user.username,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              (loggedInUser!.user.bio?.isEmpty ?? true)
                                  ? loggedInUser!.user.email
                                  : loggedInUser!.user.bio!,
                              style: w60style,
                            ),
                            if (loggedInUser!.user.bio != null &&
                                loggedInUser!.user.bio!.isNotEmpty)
                              Text(
                                loggedInUser!.user.email,
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
                  AccountDetailsSection(
                    loggedInUser: loggedInUser!,
                    eventLogs: eventLogs,
                  )
                else if (selectedTab == AccountTabs.editProfile)
                  AccountEditProfileSection(
                    loggedInUser: loggedInUser!,
                  )
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

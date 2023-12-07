import 'package:cron/cron.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_header_menu_button.dart';
import 'package:markdownnotepad/components/dashboard/sections/dashboard_last_viewed_section.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/enums/dashboard_history_item_actions.dart';
import 'package:markdownnotepad/enums/dashboard_tabs.dart';
import 'package:markdownnotepad/helpers/fill_event_log_info.dart';
import 'package:markdownnotepad/models/api_responses/event_logs_response_model.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm_list.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardTabs selectedTab = DashboardTabs.lastViewed;

  final _eventLogsBox = Hive.box<EventLogVMList>('event_logs');

  late CurrentLoggedInUserProvider loggedInUserProvider;
  late MDNApiService apiService;

  LoggedInUser? loggedInUser;
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
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 15.0 : 35.0,
          ).copyWith(
            top: Responsive.isDesktop(context) ? 48.0 : 32.0,
          ),
          child: Consumer<CurrentLoggedInUserProvider>(
            builder: (context, notifier, child) {
              if (notifier.currentUser == null) {
                Modular.to.navigate('/auth/login');
                return const SizedBox.shrink();
              }

              final LoggedInUser loggedInUser = notifier.currentUser!;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: const Text(
                            "👋 ",
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                              .animate()
                              .rotate(
                                end: 0.05,
                                duration: .75.seconds,
                              )
                              .scale(
                                end: const Offset(1.05, 1.05),
                                duration: .75.seconds,
                              )
                              .then(
                                delay: 75.ms,
                              )
                              .rotate(
                                end: -.05,
                                duration: .75.seconds,
                              )
                              .scale(
                                end: const Offset(1.0, 1.0),
                                duration: .75.seconds,
                              ),
                        ),
                        TextSpan(
                            text: loggedInUser.user.name.isNotEmpty
                                ? "Cześć, ${loggedInUser.user.name}!"
                                : "Cześć!"),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          DashboardHeaderMenuButton(
                            text: "Ostatnio wyświetlane",
                            tab: DashboardTabs.lastViewed,
                            selectedTab: selectedTab,
                            onTap: () => setState(
                              () => selectedTab = DashboardTabs.lastViewed,
                            ),
                          ),
                          // const SizedBox(width: 20.0),
                          // DashboardHeaderMenuButton(
                          //   text: "Dodane do ulubionych",
                          //   tab: DashboardTabs.addedToFavourites,
                          //   selectedTab: selectedTab,
                          //   onTap: () => setState(
                          //     () =>
                          //         selectedTab = DashboardTabs.addedToFavourites,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  if (selectedTab == DashboardTabs.lastViewed)
                    DashboardLastViewedSection(
                      loggedInUser: loggedInUser,
                      eventLogs: eventLogs,
                    )
                  // else if (selectedTab == DashboardTabs.addedToFavourites)
                  //   const DashboardFavouritesSection(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

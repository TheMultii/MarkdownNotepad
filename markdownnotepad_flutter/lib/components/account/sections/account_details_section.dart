import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:markdownnotepad/components/account/account_details_list_item.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_history_list_item.dart';
import 'package:markdownnotepad/components/notifications/error_notify_toast.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/enums/dashboard_history_item_actions.dart';
import 'package:markdownnotepad/helpers/date_helper.dart';
import 'package:markdownnotepad/models/api_responses/event_logs_response_model.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:provider/provider.dart';

class AccountDetailsSection extends StatefulWidget {
  const AccountDetailsSection({
    super.key,
  });

  @override
  State<AccountDetailsSection> createState() => _AccountDetailsSectionState();
}

class _AccountDetailsSectionState extends State<AccountDetailsSection> {
  final NotifyToast notifyToast = NotifyToast();
  late MDNApiService apiService;

  @override
  void initState() {
    super.initState();

    apiService = context.read<ApiServiceProvider>().apiService;

    getLastActivity();
  }

  Future<void> getLastActivity() async {
    try {
      final notifier = context.read<CurrentLoggedInUserProvider>();

      final EventLogsResponseModel? p = await apiService.getEventLogs(
          1, "Bearer ${notifier.currentUser!.accessToken}");

      if (p == null) return;
      // debugPrint(
      //     "page ${p.page}/${p.totalPages} -> ${p.eventLogs.length} items");
      for (final e in p.eventLogs) {
        debugPrint("E: ${e.message}");
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      // ignore: use_build_context_synchronously
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Nie udało się pobrać ostatniej aktywności",
        ),
      );
    } catch (e) {
      debugPrint("Exception: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentLoggedInUserProvider>(
      builder: (context, notifier, child) {
        if (notifier.currentUser == null) {
          Modular.to.navigate('/auth/login');
          return const SizedBox.shrink();
        }

        final loggedInUser = notifier.currentUser!;

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
                                action: DashboardHistoryItemActions.addedTag,
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
                                isLast: true,
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
      },
    );
  }
}

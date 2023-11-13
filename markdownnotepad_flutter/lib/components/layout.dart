import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/drawer/drawer.dart';
import 'package:markdownnotepad/components/no_internet_connection_alert_widget.dart';
import 'package:markdownnotepad/components/notifications/success_notify_toast.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/core/search_bar.dart';
import 'package:markdownnotepad/intents/search_intent.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';

class MDNLayout extends StatefulWidget {
  final Widget child;
  final bool displayDrawer;

  const MDNLayout({
    super.key,
    required this.child,
    required this.displayDrawer,
  });

  @override
  State<MDNLayout> createState() => _MDNLayoutState();
}

class _MDNLayoutState extends State<MDNLayout> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  final NotifyToast notifyToast = NotifyToast();
  late MDNApiService apiService;

  late Timer checkConnectionTimer;
  bool isConnectedToTheServer = true;

  @override
  void initState() {
    super.initState();

    apiService = MDNApiService(
      Dio(
        BaseOptions(contentType: "application/json"),
      ),
      baseUrl: "http://localhost:3000", //TODO: fix an url
    );

    checkConnectionTimer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer timer) async => await checkIsConnectedToTheServer(),
    );
  }

  Future<void> checkIsConnectedToTheServer() async {
    try {
      final miscData = await apiService.getMiscellaneous();
      if (!mounted) return;
      if (miscData?.name != "MarkdownNotepad API") {
        setState(() {
          isConnectedToTheServer = false;
        });
        return;
      }
      if (isConnectedToTheServer) return;

      notifyToast.show(
        context: context,
        child: const SuccessNotifyToast(
          title: "Pomyślnie połączono z serwerem",
          titleTextStyle: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      );
      setState(() {
        isConnectedToTheServer = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isConnectedToTheServer = false;
      });
    }
  }

  @override
  void dispose() {
    checkConnectionTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context) &&
        drawerKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }

    return Scaffold(
      key: drawerKey,
      drawer: const MDNDrawer(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isConnectedToTheServer)
              NoInternetConnectionAlertWidget(
                checkIsConnectedToTheServer: checkIsConnectedToTheServer,
              ),
            Expanded(
              child: Row(
                children: [
                  Responsive.isDesktop(context) && widget.displayDrawer
                      ? const Expanded(
                          flex: 2,
                          child: MDNDrawer(),
                        )
                      : Container(),
                  Expanded(
                    flex: 7,
                    child: Focus(
                      autofocus: true,
                      focusNode: FocusNode()..requestFocus(),
                      child: MDNSearchIntent(
                        invokeFunction: (Intent intent) {
                          debugPrint(
                              "SearchIntent invoked at ${DateTime.now()}");

                          //push a new route on top of the current one, with a transparent background
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (_, __, ___) => MDNSearchBarWidget(
                                dismissEntry: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          );
                        },
                        child: widget.child,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/drawer/drawer.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/intents/search_intent.dart';

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
              child: MDNSearchIntent(
                invokeFunction: (Intent intent) {
                  debugPrint("SearchIntent invoked at ${DateTime.now()}");
                },
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

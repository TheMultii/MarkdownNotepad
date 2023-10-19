import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/drawer/drawer.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';

class MDNLayout extends StatelessWidget {
  final Widget child;

  const MDNLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

    final isDesktop = Responsive.isDesktop(context);

    if (isDesktop && drawerKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }

    return Scaffold(
      key: drawerKey,
      drawer: const MDNDrawer(),
      body: SafeArea(
        child: Row(
          children: [
            isDesktop
                ? const Expanded(
                    flex: 2,
                    child: MDNDrawer(),
                  )
                : Container(),
            Expanded(
              flex: 7,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

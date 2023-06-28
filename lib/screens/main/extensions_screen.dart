import 'package:flutter/material.dart';
import 'package:mdn/components/drawer/drawer.dart';
import 'package:mdn/responsive.dart';

class ExtensionsScreen extends StatefulWidget {
  const ExtensionsScreen({super.key});

  @override
  State<ExtensionsScreen> createState() => _ExtensionsScreenState();
}

final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();

class _ExtensionsScreenState extends State<ExtensionsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    if (isDesktop && _drawerKey.currentState?.isDrawerOpen == true) {
      _drawerKey.currentState?.closeDrawer();
    }

    return Scaffold(
      key: _drawerKey,
      drawer: const MDNDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://source.unsplash.com/collection/256524/1280x720",
                  isAntiAlias: true,
                  width: isDesktop
                      ? ((MediaQuery.of(context).size.width / 9) * 7)
                      : MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
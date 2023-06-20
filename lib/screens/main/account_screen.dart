import 'package:flutter/material.dart';
import 'package:mdn/components/drawer/drawer.dart';
import 'package:mdn/responsive.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();

class _AccountScreenState extends State<AccountScreen> {
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
                  "https://source.unsplash.com/collection/9663343/1280x720",
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

import 'package:flutter/material.dart';
import 'package:mdn/components/drawer/drawer.dart';
import 'package:mdn/components/home_screen/home_screen_header_menu_button.dart';
import 'package:mdn/components/home_screen/home_screen_last_viewed_cards.dart';
import 'package:mdn/providers/fetch_user_data_drawer_provider.dart';
import 'package:mdn/responsive.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String selectedHeaderText = "Ostatnio wyświetlane";

  void onHeaderMenuButtonTap(String currentlySelected) =>
      setState(() => selectedHeaderText = currentlySelected);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();

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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36)
                    .copyWith(top: 60),
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "👋 Cześć, Marcel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 37),
                      child: Row(
                        children: [
                          HeaderMenuButton(
                            onTap: onHeaderMenuButtonTap,
                            text: "Ostatnio wyświetlane",
                            isSelected:
                                selectedHeaderText == "Ostatnio wyświetlane",
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          HeaderMenuButton(
                            onTap: onHeaderMenuButtonTap,
                            text: "Dodane do ulubionych",
                            isSelected:
                                selectedHeaderText == "Dodane do ulubionych",
                          ),
                        ],
                      ),
                    ),
                    selectedHeaderText == "Ostatnio wyświetlane"
                        ? HomeScreenLastView(
                            minWidth:
                                (MediaQuery.of(context).size.width / 9) * 7,
                          )
                        : const Text("Dodane do ulubionych"),
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final fetchDataDrawer =
                                Provider.of<FetchUserDataDrawerProvider>(
                                    context,
                                    listen: false);
                            fetchDataDrawer.updateRandomName();

                            if (!isDesktop) {
                              _drawerKey.currentState?.openDrawer();
                            }
                          },
                          child: const Text("Zmień użytkownika"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

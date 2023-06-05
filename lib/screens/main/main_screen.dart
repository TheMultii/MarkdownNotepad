import 'package:flutter/material.dart';
import 'package:mdn/components/drawer/drawer.dart';
import 'package:mdn/components/home_screen/home_screen_header_menu_button.dart';
import 'package:mdn/components/home_screen/home_screen_last_viewed_cards.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Map<String, dynamic>> drawerNotesTiles = [
    {
      "name": "Lorem ipsum",
      "icon": Icons.description_outlined,
    },
    {
      "name": "BleBleBle",
      "icon": Icons.description_outlined,
    },
    {
      "name": "Notatka bez tytułu",
      "icon": Icons.description_outlined,
    }
  ];

  final List<Map<String, dynamic>> drawerFolderTiles = [
    {
      "name": "Folder 1",
      "icon": Icons.folder_outlined,
    },
    {
      "name": "Folder 2",
      "icon": Icons.folder_outlined,
    }
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Ink(
              color: Theme.of(context).colorScheme.inverseSurface,
              child: MDNDrawer(
                  drawerNotesTiles: drawerNotesTiles,
                  drawerFolderTiles: drawerFolderTiles),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 36).copyWith(top: 60),
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
                          minWidth: (MediaQuery.of(context).size.width / 9) * 7,
                        )
                      : const Text("Dodane do ulubionych"),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

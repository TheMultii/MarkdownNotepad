import 'package:flutter/material.dart';
import 'package:mdn/components/drawer.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final String currentSelected = "Dashboard";
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
                  currentSelected: currentSelected,
                  drawerNotesTiles: drawerNotesTiles,
                  drawerFolderTiles: drawerFolderTiles),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              color: Theme.of(context).colorScheme.background,
              child: const Align(
                alignment: Alignment.center,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: []),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

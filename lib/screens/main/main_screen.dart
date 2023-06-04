import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdn/components/drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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

  String imageurl = "https://api.mganczarczyk.pl/tairiku/random/streetmoe";

  bool _onKeyPressed(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (event is KeyDownEvent) {
      if (key != "F5") return false;

      setState(() {
        imageurl =
            "https://api.mganczarczyk.pl/tairiku/random/streetmoe?safety=true&id=${DateTime.now().millisecondsSinceEpoch}";
      });
      debugPrint("Refreshing image -> $imageurl");
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKeyPressed);
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKeyPressed);
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
                  currentSelected: currentSelected,
                  drawerNotesTiles: drawerNotesTiles,
                  drawerFolderTiles: drawerFolderTiles),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              color: Theme.of(context).colorScheme.background,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        imageurl,
                        height: MediaQuery.of(context).size.height * 0.9,
                      ),
                      Text(imageurl),
                    ]),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

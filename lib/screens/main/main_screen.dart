import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdn/components/drawer.dart';

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

  String imageurl = "https://api.mganczarczyk.pl/tairiku/random/streetmoe";
  String selectedHeaderText = "Ostatnio wyświetlane";

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

  void onHeaderMenuButtonTap(String currentlySelected) =>
      setState(() => selectedHeaderText = currentlySelected);

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
                  drawerNotesTiles: drawerNotesTiles,
                  drawerFolderTiles: drawerFolderTiles),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 36).copyWith(top: 75),
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
                    Text(imageurl),
                  ]),
            ),
          ),
        ],
      )),
    );
  }
}

class HeaderMenuButton extends StatelessWidget {
  const HeaderMenuButton({
    super.key,
    required this.text,
    this.isSelected = false,
    this.onTap,
  });

  final String text;
  final bool isSelected;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 1,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 1.5,
          ),
        ),
      ),
      child: RichText(
        text: TextSpan(
          //operator kaskadowy (..)
          recognizer: TapGestureRecognizer()..onTap = () => onTap!(text),
          text: text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdn/components/drawer/drawer_bottom_profile.dart';
import 'package:mdn/components/drawer/drawer_create_new_note_button.dart';
import 'package:mdn/components/drawer/drawer_list_divider.dart';
import 'package:mdn/components/drawer/drawer_list_tile.dart';

class MDNDrawer extends StatefulWidget {
  const MDNDrawer({
    super.key,
    this.currentSelected = "Dashboard",
    required this.drawerNotesTiles,
    required this.drawerFolderTiles,
  });

  final String currentSelected;
  final List<Map<String, dynamic>> drawerNotesTiles;
  final List<Map<String, dynamic>> drawerFolderTiles;

  @override
  State<MDNDrawer> createState() => _MDNDrawerState();
}

class _MDNDrawerState extends State<MDNDrawer> {
  String currentSelected = "Dashboard";

  @override
  void initState() {
    super.initState();
    currentSelected = widget.currentSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: ListView(
                children: [
                  //app logo
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          width: 56,
                          height: 56,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Markdown Notepad",
                          style: GoogleFonts.getFont(
                            'Plus Jakarta Sans',
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //create new note button
                  const DrawerCreateNewNoteButton(),
                  //scrollable menu list
                  DrawerListTile(
                    title: "Dashboard",
                    selected: currentSelected == "Dashboard",
                    textOpacity: currentSelected == "Dashboard" ? 1.0 : 0.6,
                    icon: Icons.dashboard_rounded,
                    onTap: () {
                      handleDrawerItemClick("Dashboard");
                    },
                  ),
                  const DrawerListDivider(title: "Ostatnie notatki"),
                  for (var note in widget.drawerNotesTiles)
                    DrawerListTile(
                      title: note["name"],
                      icon: note["icon"],
                      onTap: () {
                        handleDrawerItemClick(note["name"]);
                      },
                      selected: currentSelected == note["name"],
                      textOpacity: currentSelected == note["name"] ? 1.0 : 0.6,
                    ),
                  const DrawerListDivider(title: "Foldery"),
                  for (var folder in widget.drawerFolderTiles)
                    DrawerListTile(
                      title: folder["name"],
                      icon: folder["icon"],
                      onTap: () {
                        handleDrawerItemClick(folder["name"]);
                      },
                      selected: currentSelected == folder["name"],
                      textOpacity:
                          currentSelected == folder["name"] ? 1.0 : 0.6,
                    ),
                  const DrawerListDivider(title: "Miscellaneous"),
                  DrawerListTile(
                    title: "Konto",
                    icon: Icons.account_circle_outlined,
                    selected: currentSelected == "Konto",
                    textOpacity: currentSelected == "Konto" ? 1.0 : 0.6,
                    onTap: () {
                      handleDrawerItemClick("Konto");
                    },
                  ),
                  DrawerListTile(
                    title: "Rozszerzenia",
                    icon: Icons.extension_outlined,
                    selected: currentSelected == "Rozszerzenia",
                    textOpacity: currentSelected == "Rozszerzenia" ? 1.0 : 0.6,
                    onTap: () {
                      handleDrawerItemClick("Rozszerzenia");
                    },
                  ),
                ],
              ),
            ),
          ),

          //user profile
          const BottomDrawerProfile(
            loggedInUserColorStatus: Color(0xFF1CD43A),
            loggedInUserName: "TheMultii",
          ),
        ],
      ),
    );
  }

  void handleDrawerItemClick(drawerItemName) {
    setState(() {
      currentSelected = drawerItemName;
    });
  }
}

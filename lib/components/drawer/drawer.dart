import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdn/components/drawer/drawer_bottom_profile.dart';
import 'package:mdn/components/drawer/drawer_create_new_note_button.dart';
import 'package:mdn/components/drawer/drawer_list_divider.dart';
import 'package:mdn/components/drawer/drawer_list_tile.dart';
import 'package:mdn/config/router.dart';
import 'package:mdn/providers/data_drawer_provider.dart';
import 'package:mdn/providers/fetch_user_data_drawer_provider.dart';
import 'package:provider/provider.dart';

class MDNDrawer extends StatefulWidget {
  const MDNDrawer({super.key, this.currentSelected = ""});

  final String currentSelected;

  @override
  State<MDNDrawer> createState() => _MDNDrawerState();
}

class _MDNDrawerState extends State<MDNDrawer> {
  String currentSelected = "Dashboard";
  Timer? _scrollEndTimer;

  @override
  void initState() {
    super.initState();
    currentSelected = widget.currentSelected == ""
        ? getRouteName(router.location)
        : widget.currentSelected;
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _scrollEndTimer?.cancel();
    super.dispose();
  }

  ScrollController? _scrollController;

  @override
  Widget build(BuildContext context) {
    final fetchDataDrawerProvider =
        Provider.of<FetchUserDataDrawerProvider>(context);
    final dataDrawerProvider = Provider.of<DataDrawerProvider>(context);

    double scrollPosition = dataDrawerProvider.scrollPosition;
    _scrollController = ScrollController(initialScrollOffset: scrollPosition);
    _scrollController?.addListener(_onScroll);

    return Drawer(
      elevation: 0,
      child: Column(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: ListView(
                controller: _scrollController,
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
                      router.replace("/");
                    },
                  ),
                  const DrawerListDivider(title: "Ostatnie notatki"),
                  for (var note in dataDrawerProvider.drawerNotesTiles)
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
                  for (var folder in dataDrawerProvider.drawerFolderTiles)
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
                    title: "[TEMP] Zaloguj",
                    icon: Icons.login_outlined,
                    selected: false,
                    textOpacity: 0.6,
                    onTap: () {
                      router.replace("/login");
                    },
                  ),
                  DrawerListTile(
                    title: "Konto",
                    icon: Icons.account_circle_outlined,
                    selected: currentSelected == "Konto",
                    textOpacity: currentSelected == "Konto" ? 1.0 : 0.6,
                    onTap: () {
                      router.replace("/account");
                    },
                  ),
                  DrawerListTile(
                    title: "Rozszerzenia",
                    icon: Icons.extension_outlined,
                    selected: currentSelected == "Rozszerzenia",
                    textOpacity: currentSelected == "Rozszerzenia" ? 1.0 : 0.6,
                    onTap: () {
                      router.replace("/extensions");
                    },
                  ),
                  DrawerListTile(
                    title: "Ustawienia",
                    icon: Icons.settings_outlined,
                    selected: currentSelected == "Ustawienia",
                    textOpacity: currentSelected == "Ustawienia" ? 1.0 : 0.6,
                    onTap: () {
                      router.replace("/settings");
                    },
                  ),
                ],
              ),
            ),
          ),

          //user profile
          BottomDrawerProfile(
            loggedInUserColorStatus: const Color(0xFF1CD43A),
            loggedInUserName: fetchDataDrawerProvider.userName,
            loggedInUserThumbnail: fetchDataDrawerProvider.thumbnailAvatar,
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

  void _onScroll() {
    if (_scrollEndTimer != null && _scrollEndTimer!.isActive) {
      _scrollEndTimer!.cancel();
    }
    _scrollEndTimer =
        Timer(const Duration(milliseconds: 200), _handleScrollEnd);
  }

  void _handleScrollEnd() {
    if (_scrollController == null) return;
    final dataDrawerProvider =
        Provider.of<DataDrawerProvider>(context, listen: false);
    dataDrawerProvider.setScrollPosition(_scrollController!.position.pixels);
  }
}

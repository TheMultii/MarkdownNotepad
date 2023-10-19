import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:markdownnotepad/components/drawer/drawer_footer.dart';
import 'package:markdownnotepad/components/drawer/drawer_header.dart';
import 'package:markdownnotepad/components/drawer/drawer_item.dart';
import 'package:markdownnotepad/components/drawer/drawer_item_section.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/providers/data_drawer_provider.dart';
import 'package:provider/provider.dart';

class MDNDrawer extends StatefulWidget {
  const MDNDrawer({super.key});

  @override
  State<MDNDrawer> createState() => _MDNDrawerState();
}

class _MDNDrawerState extends State<MDNDrawer> {
  late ScrollController _scrollController;
  Timer? _scrollEndTimer;

  int currentSelectedIndex = -1;

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollEndTimer != null && _scrollEndTimer!.isActive) {
      _scrollEndTimer!.cancel();
    }
    _scrollEndTimer =
        Timer(const Duration(milliseconds: 200), _handleScrollEnd);
  }

  void _handleScrollEnd() {
    final dataDrawerProvider =
        Provider.of<DataDrawerProvider>(context, listen: false);
    dataDrawerProvider.setScrollPosition(_scrollController.position.pixels);
  }

  void onCreateNewNotePressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nowa notatka"),
          content: const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Nazwa notatki",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Anuluj"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Utwórz"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataDrawerProvider = Provider.of<DataDrawerProvider>(context);
    final MarkdownNotepadTheme? extendedTheme =
        Theme.of(context).extension<MarkdownNotepadTheme>();

    double scrollPosition = dataDrawerProvider.scrollPosition;
    _scrollController = ScrollController(initialScrollOffset: scrollPosition);
    _scrollController.addListener(_onScroll);

    return Drawer(
      elevation: 0,
      backgroundColor: extendedTheme?.drawerBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const MDNDrawerHeader(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton.icon(
                        onPressed: () => onCreateNewNotePressed(context),
                        icon: Icon(
                          FeatherIcons.plus,
                          size: 17,
                          color: extendedTheme?.text,
                        ),
                        label: Text(
                          "Nowa notatka",
                          style: TextStyle(
                            fontSize: 16,
                            color: extendedTheme?.text,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.grey.shade900,
                          foregroundColor: extendedTheme?.drawerBackground,
                          surfaceTintColor:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MDNDrawerItem(
                      icon: FeatherIcons.user,
                      title: "Dashboard",
                      isSelected: -1 == currentSelectedIndex,
                      onPressed: () =>
                          setState(() => currentSelectedIndex = -1),
                    ),
                    const MDNDrawerItemSection(title: "Ostatnie notatki"),
                    ...List.generate(
                      20,
                      (index) {
                        return MDNDrawerItem(
                          icon: FeatherIcons.folder,
                          title: "Strona główna - ${index + 1}",
                          isSelected: index == currentSelectedIndex,
                          onPressed: () =>
                              setState(() => currentSelectedIndex = index),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            const MDNDrawerFooter(
              avatarUrl:
                  "https://gitlab.mganczarczyk.pl/uploads/-/system/user/avatar/1/avatar.png",
              username: "TheMultii",
            ),
          ],
        ),
      ),
    );
  }
}

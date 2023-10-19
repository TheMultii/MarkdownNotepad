import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
  late String currentTab;

  late ScrollController _scrollController;
  Timer? _scrollEndTimer;

  @override
  void initState() {
    super.initState();

    currentTab = Modular.to.path;
    if (currentTab == "/") {
      currentTab = "/dashboard/";
    }
  }

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

  bool isTabSelected(String tab) =>
      currentTab.toLowerCase() == tab.toLowerCase();

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
                      icon: FeatherIcons.pocket,
                      title: "Dashboard",
                      isSelected: isTabSelected("/dashboard/"),
                      onPressed: () {
                        const String destination = "/dashboard/";

                        setState(() {
                          currentTab = destination;
                        });
                        Modular.to.navigate(
                          destination,
                          arguments: {
                            "id": Random().nextInt(100000),
                          },
                        );
                      },
                    ),
                    const MDNDrawerItemSection(title: "Ostatnie notatki"),
                    ...List.generate(
                      3,
                      (index) {
                        return MDNDrawerItem(
                          icon: FeatherIcons.file,
                          title: "Przykładowa notatka - ${index + 1}",
                          isSelected: isTabSelected("/editor/${index + 1}"),
                          onPressed: () {
                            final String destination = "/editor/${index + 1}";
                            setState(() {
                              currentTab = destination;
                            });
                            Modular.to.navigate(
                              destination,
                            );
                          },
                        );
                      },
                    ),
                    const MDNDrawerItemSection(title: "Foldery"),
                    ...List.generate(
                      3,
                      (index) {
                        return MDNDrawerItem(
                          icon: FeatherIcons.folder,
                          title: "Folder ${index + 1}",
                          isSelected: isTabSelected("/directory/${index + 1}"),
                          onPressed: () {
                            final String destination =
                                "/directory/${index + 1}";
                            setState(() {
                              currentTab = destination;
                            });
                            Modular.to.navigate(
                              "/dashboard/",
                              arguments: {
                                "id": Random().nextInt(100000) + index + 1,
                              },
                            );
                          },
                        );
                      },
                    ),
                    const MDNDrawerItemSection(title: "Miscellaneous"),
                    MDNDrawerItem(
                      icon: FeatherIcons.user,
                      title: "Konto",
                      isSelected: isTabSelected("/miscellaneous/account"),
                      onPressed: () {
                        const String destination = "/miscellaneous/account";

                        setState(() {
                          currentTab = destination;
                        });
                        Modular.to.navigate(
                          destination,
                          arguments: {
                            "id": Random().nextInt(100000),
                          },
                        );
                      },
                    ),
                    MDNDrawerItem(
                      icon: FeatherIcons.package,
                      title: "Rozszerzenia",
                      isSelected: isTabSelected("/miscellaneous/extensions"),
                      onPressed: () {
                        const String destination = "/miscellaneous/extensions";

                        setState(() {
                          currentTab = destination;
                        });
                        Modular.to.navigate(
                          destination,
                          arguments: {
                            "id": Random().nextInt(100000),
                          },
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
              avatarUrl: "https://api.mganczarczyk.pl/user/TheMultii/profile",
              username: "TheMultii",
            ),
          ],
        ),
      ),
    );
  }
}

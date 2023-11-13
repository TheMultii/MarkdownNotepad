import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/components/drawer/drawer_footer.dart';
import 'package:markdownnotepad/components/drawer/drawer_header.dart';
import 'package:markdownnotepad/components/drawer/drawer_item.dart';
import 'package:markdownnotepad/components/drawer/drawer_item_section.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/providers/data_drawer_provider.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:provider/provider.dart';

class MDNDrawer extends StatefulWidget {
  const MDNDrawer({super.key});

  @override
  State<MDNDrawer> createState() => _MDNDrawerState();
}

class _MDNDrawerState extends State<MDNDrawer> {
  late ScrollController _scrollController;
  Timer? _scrollEndTimer;

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollEndTimer?.cancel();
    _scrollController.dispose();
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
          title: const Text(
            "Nowa notatka",
            textAlign: TextAlign.center,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nazwa notatki",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Hasło notatki",
                ),
              ),
            ],
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
        ).animate().fadeIn(duration: 100.ms).scale(
              duration: 100.ms,
              curve: Curves.easeInOut,
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
            );
      },
    );
  }

  void onCreateNewCatalogPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Nowy folder",
            textAlign: TextAlign.center,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nazwa folderu",
                ),
              ),
            ],
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
        ).animate().fadeIn(duration: 100.ms).scale(
              duration: 100.ms,
              curve: Curves.easeInOut,
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
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
            Consumer<DrawerCurrentTabProvider>(
                builder: (context, notifier, child) {
              bool isTabSelected(String tab) =>
                  notifier.currentTab.toLowerCase() == tab.toLowerCase();

              return Expanded(
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

                          notifier.setCurrentTab(destination);
                          Modular.to.navigate(
                            destination,
                          );
                        },
                      ),
                      MDNDrawerItemSection(
                        title: "Ostatnie notatki",
                        icon: Icon(
                          FeatherIcons.plus,
                          size: 12,
                          color: extendedTheme?.text,
                        ),
                        iconClickCallback: () =>
                            onCreateNewNotePressed(context),
                      ),
                      ...List.generate(
                        3,
                        (index) {
                          return MDNDrawerItem(
                            icon: FeatherIcons.file,
                            title: "Przykładowa notatka - ${index + 1}",
                            isSelected: isTabSelected("/editor/${index + 1}"),
                            onPressed: () {
                              final String destination = "/editor/${index + 1}";

                              notifier.setCurrentTab(destination);
                              Modular.to.navigate(
                                destination,
                              );
                            },
                          );
                        },
                      ),
                      MDNDrawerItemSection(
                        title: "Foldery",
                        icon: Icon(
                          FeatherIcons.plus,
                          size: 12,
                          color: extendedTheme?.text,
                        ),
                        iconClickCallback: () =>
                            onCreateNewCatalogPressed(context),
                      ),
                      ...List.generate(
                        3,
                        (index) {
                          return MDNDrawerItem(
                            icon: FeatherIcons.folder,
                            title: "Folder ${index + 1}",
                            isSelected: isTabSelected(
                                "/dashboard/directory/${index + 1}"),
                            onPressed: () {
                              final String destination =
                                  "/dashboard/directory/${index + 1}";

                              notifier.setCurrentTab(destination);
                              Modular.to.navigate(
                                destination,
                                arguments: {
                                  "cardsCount":
                                      index == 1 ? 0 : Random().nextInt(10) + 5
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

                          notifier.setCurrentTab(destination);
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
                          const String destination =
                              "/miscellaneous/extensions";

                          notifier.setCurrentTab(destination);
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
              );
            }),
            const MDNDrawerFooter(),
          ],
        ),
      ),
    );
  }
}

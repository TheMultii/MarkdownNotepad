import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:markdownnotepad/components/alertdialogs/create_new_catalog_alert_dialog.dart';
import 'package:markdownnotepad/components/alertdialogs/create_new_note_alert_dialog.dart';
import 'package:markdownnotepad/components/drawer/drawer_footer.dart';
import 'package:markdownnotepad/components/drawer/drawer_header.dart';
import 'package:markdownnotepad/components/drawer/drawer_item.dart';
import 'package:markdownnotepad/components/drawer/drawer_item_section.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/models/catalog.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/providers/data_drawer_provider.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
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
        return const CreateNewNoteAlertDialog();
      },
    );
  }

  void onCreateNewCatalogPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const CreateNewCatalogAlertDialog();
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

              return Consumer<CurrentLoggedInUserProvider>(
                  builder: (contextUser, notifierUser, childUser) {
                final LoggedInUser? loggedInUser = notifierUser.currentUser;

                if (loggedInUser == null) return const SizedBox();

                final List<Catalog> catalogsSorted =
                    loggedInUser.user.catalogs == null
                        ? []
                        : loggedInUser.user.catalogs!
                      ..sort(
                        (a, b) => b.updatedAt.compareTo(a.updatedAt),
                      );

                final List<Note> notesSorted = loggedInUser.user.notes == null
                    ? []
                    : loggedInUser.user.notes!
                  ..sort(
                    (a, b) => b.updatedAt.compareTo(a.updatedAt),
                  );

                return Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: LayoutBuilder(builder: (lbcst, lbconstr) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        context
                            .read<DataDrawerProvider>()
                            .setDrawerWidth(lbconstr.maxWidth);
                      });
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                                foregroundColor:
                                    extendedTheme?.drawerBackground,
                                surfaceTintColor:
                                    Theme.of(context).brightness ==
                                            Brightness.light
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
                          ...notesSorted
                              .getRange(
                                  0,
                                  notesSorted.length >= 3
                                      ? 3
                                      : notesSorted.length)
                              .map(
                            (note) {
                              return MDNDrawerItem(
                                icon: FeatherIcons.file,
                                title: note.title,
                                isSelected: isTabSelected("/editor/${note.id}"),
                                onPressed: () {
                                  final String destination =
                                      "/editor/${note.id}";

                                  notifier.setCurrentTab(destination);
                                  Modular.to.navigate(
                                    destination,
                                    arguments: {
                                      "noteTitle": note.title,
                                    },
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
                          ...catalogsSorted
                              .getRange(
                                  0,
                                  catalogsSorted.length >= 3
                                      ? 3
                                      : catalogsSorted.length)
                              .map((catalog) {
                            return MDNDrawerItem(
                              icon: FeatherIcons.folder,
                              title: catalog.title,
                              isSelected: isTabSelected(
                                  "/dashboard/directory/${catalog.id}"),
                              onPressed: () {
                                final String destination =
                                    "/dashboard/directory/${catalog.id}";

                                notifier.setCurrentTab(destination);
                                Modular.to.navigate(
                                  destination,
                                  arguments: {
                                    "catalogName": catalog.title,
                                  },
                                );
                              },
                            );
                          }),
                          const MDNDrawerItemSection(title: "Miscellaneous"),
                          MDNDrawerItem(
                            icon: FeatherIcons.user,
                            title: "Konto",
                            isSelected: isTabSelected("/miscellaneous/account"),
                            onPressed: () {
                              const String destination =
                                  "/miscellaneous/account";

                              notifier.setCurrentTab(destination);
                              Modular.to.navigate(
                                destination,
                              );
                            },
                          ),
                          MDNDrawerItem(
                            icon: FeatherIcons.package,
                            title: "Rozszerzenia",
                            isSelected:
                                isTabSelected("/miscellaneous/extensions"),
                            onPressed: () {
                              const String destination =
                                  "/miscellaneous/extensions";

                              notifier.setCurrentTab(destination);
                              Modular.to.navigate(
                                destination,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    }),
                  ),
                );
              });
            }),
            const MDNDrawerFooter(),
          ],
        ),
      ),
    );
  }
}

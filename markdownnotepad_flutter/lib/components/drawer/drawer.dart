import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:markdownnotepad/components/alertdialogs/create_new_catalog_alert_dialog.dart';
import 'package:markdownnotepad/components/alertdialogs/create_new_note_alert_dialog.dart';
import 'package:markdownnotepad/components/alertdialogs/create_new_notetag_alert_dialog.dart';
import 'package:markdownnotepad/components/drawer/drawer_footer.dart';
import 'package:markdownnotepad/components/drawer/drawer_header.dart';
import 'package:markdownnotepad/components/drawer/drawer_item.dart';
import 'package:markdownnotepad/components/drawer/drawer_item_section.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/core/search_bar.dart';
import 'package:markdownnotepad/helpers/color_converter.dart';
import 'package:markdownnotepad/models/catalog.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/models/notetag.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/providers/data_drawer_provider.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:material_symbols_icons/symbols.dart';
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

  void onCreateNewNoteTagPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const CreateNewNoteTagAlertDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataDrawerProvider = Provider.of<DataDrawerProvider>(context);
    final MarkdownNotepadTheme? extendedTheme =
        Theme.of(context).extension<MarkdownNotepadTheme>();

    _scrollController = ScrollController(
      initialScrollOffset: dataDrawerProvider.scrollPosition,
    )..addListener(_onScroll);

    final bool isMobile = Responsive.isMobile(context);

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

                final List<NoteTag> noteTagsSorted = loggedInUser.user.tags ==
                        null
                    ? []
                    : loggedInUser.user.tags!
                  ..sort(
                    (a, b) => a.title.compareTo(b.title),
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
                          isMobile
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 30.0 : 20.0,
                                  ).copyWith(
                                    bottom: 10,
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Scaffold.of(context).openEndDrawer();

                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder: (_, __, ___) =>
                                              const MDNSearchBarWidget(),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Symbols.search,
                                      size: 17,
                                      color: extendedTheme?.text,
                                    ),
                                    label: Text(
                                      "Wyszukaj",
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
                                      padding: EdgeInsets.symmetric(
                                        vertical: isMobile ? 7 : 15,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 30.0 : 20.0,
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () => onCreateNewNotePressed(context),
                              icon: Icon(
                                Symbols.add,
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
                                padding: EdgeInsets.symmetric(
                                  vertical: isMobile ? 7 : 15,
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
                              Symbols.add,
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
                                icon: Symbols.note,
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
                              Symbols.add,
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
                              icon: Symbols.folder,
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
                          MDNDrawerItemSection(
                            title: "Tagi",
                            icon: Icon(
                              Symbols.add,
                              size: 12,
                              color: extendedTheme?.text,
                            ),
                            iconClickCallback: () =>
                                onCreateNewNoteTagPressed(context),
                          ),
                          ...noteTagsSorted.map((tag) {
                            return MDNDrawerItem(
                              icon: Symbols.label,
                              iconFill: 1,
                              iconColor: ColorConverter.parseFromHex(tag.color),
                              title: tag.title,
                              isSelected: isTabSelected("/tag/${tag.id}"),
                              onPressed: () {
                                final String destination = "/tag/${tag.id}";

                                notifier.setCurrentTab(destination);
                                Modular.to.navigate(
                                  destination,
                                  arguments: {
                                    "tagName": tag.title,
                                  },
                                );
                              },
                            );
                          }),
                          const MDNDrawerItemSection(
                            title: "Miscellaneous",
                          ),
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
                          MDNDrawerItem(
                            icon: Symbols.policy,
                            title: "Licencje",
                            isSelected: isTabSelected("/miscellaneous/legal"),
                            onPressed: () {
                              const String destination = "/miscellaneous/legal";

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

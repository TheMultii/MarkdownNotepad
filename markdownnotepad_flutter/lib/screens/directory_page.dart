// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/components/alertdialogs/assign_note_to_catalog_alert_dialog.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_card.dart';
import 'package:markdownnotepad/components/directory/directory_page_empty.dart';
import 'package:markdownnotepad/components/notifications/error_notify_toast.dart';
import 'package:markdownnotepad/components/notifications/success_notify_toast.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/models/api_models/patch_catalog_body_model.dart';
import 'package:markdownnotepad/models/api_models/patch_note_body_model.dart';
import 'package:markdownnotepad/models/api_responses/patch_note_response_model.dart';
import 'package:markdownnotepad/models/catalog.dart';
import 'package:markdownnotepad/models/catalog_simple.dart';
import 'package:markdownnotepad/models/note_simple.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/providers/data_drawer_provider.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class DirectoryPage extends StatefulWidget {
  final String directoryId;

  const DirectoryPage({
    super.key,
    required this.directoryId,
  });

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  final NotifyToast notifyToast = NotifyToast();
  final TextEditingController newDirectoryNameController =
      TextEditingController();

  late String directoryName;
  late MDNApiService apiService;
  late CurrentLoggedInUserProvider loggedInUserProvider;

  late LoggedInUser? loggedInUser;
  late String authorizationString;

  late Catalog? catalogData;

  Offset cursorPosition = Offset.zero;

  @override
  void initState() {
    super.initState();

    directoryName = Modular.args.data?['catalogName'] as String? ?? '';
    newDirectoryNameController.text = directoryName;

    loggedInUserProvider = context.read<CurrentLoggedInUserProvider>();
    apiService = context.read<ApiServiceProvider>().apiService;

    loggedInUser = loggedInUserProvider.currentUser;
    authorizationString = "Bearer ${loggedInUser?.accessToken}";

    if (loggedInUser == null) {
      Modular.to.navigate('/auth/login');
      return;
    }

    catalogData = loggedInUser!.user.catalogs?.firstWhere(
      (element) => element.id == widget.directoryId,
    );
    getCatalogData();
  }

  Future<void> getCatalogData() async {
    try {
      Catalog? newCatalogData = await apiService
          .getCatalog(
            widget.directoryId,
            authorizationString,
          )
          ?.then(
            (value) => value.catalog,
          );

      if (newCatalogData == null) return;

      if (!mounted) return;

      setState(() {
        catalogData = newCatalogData;
      });

      newDirectoryNameController.text = newCatalogData.title;

      final newUser = loggedInUser;
      newUser!.user.catalogs?.forEach((element) {
        if (element.id == widget.directoryId) {
          element = newCatalogData;
        }
      });
      loggedInUserProvider.setCurrentUser(newUser);
    } on DioException catch (e) {
      Modular.to.navigate('/dashboard/');
      debugPrint(e.toString());
    } catch (e) {
      Modular.to.navigate('/dashboard/');
      debugPrint(e.toString());
    }
  }

  Future<void> updateCatalogName() async {
    if (MDNValidator.validateCatalogName(newDirectoryNameController.text) !=
        null) {
      return;
    }

    if (catalogData?.title == directoryName) return;

    final PatchCatalogBodyModel patchModel = PatchCatalogBodyModel(
      title: directoryName,
    );

    try {
      final resp = await apiService.patchCatalog(
        widget.directoryId,
        patchModel,
        authorizationString,
      );

      if (resp == null) {
        notifyToast.show(
          context: context,
          child: const ErrorNotifyToast(
            title: "Wystąpił błąd",
            body: "Wystąpił błąd podczas edytowania nazwy katalogu.",
          ),
        );
        return;
      }

      final newUser = loggedInUser;
      newUser!.user.catalogs?.forEach((element) {
        if (element.id == widget.directoryId) {
          element.title = directoryName;
          element.updatedAt = resp.catalog.updatedAt;
        }
      });
      loggedInUserProvider.setCurrentUser(newUser);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteCatalog() async {
    if (catalogData?.notes!.isNotEmpty ?? true) {
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Wystąpił błąd",
          body: "Nie można usunąć katalogu, który nie jest pusty.",
        ),
      );
      return;
    }

    try {
      final resp = await apiService.deleteCatalog(
        widget.directoryId,
        authorizationString,
      );

      if (resp == null) {
        notifyToast.show(
          context: context,
          child: const ErrorNotifyToast(
            title: "Wystąpił błąd",
            body: "Wystąpił błąd podczas usuwania katalogu.",
          ),
        );
        return;
      }

      final newUser = loggedInUser;
      newUser!.user.catalogs?.removeWhere(
        (element) => element.id == widget.directoryId,
      );
      loggedInUserProvider.setCurrentUser(newUser);
      Modular.to.navigate("/dashboard/");
    } catch (e) {
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Wystąpił błąd",
          body: "Wystąpił błąd podczas usuwania katalogu.",
        ),
      );
      debugPrint(e.toString());
    }
  }

  Future<void> createNewNote() async {
    //TODO: create new note in this catalog
  }

  Future<void> removeFromDirectory(String noteID) async {
    try {
      final resp = await apiService.disconnectNoteFromCatalog(
        widget.directoryId,
        noteID,
        authorizationString,
      );

      if (resp == null) {
        notifyToast.show(
          context: context,
          child: const ErrorNotifyToast(
            title: "Wystąpił błąd",
            body: "Wystąpił błąd podczas usuwania notatki z katalogu.",
          ),
        );
        return;
      }

      final newUser = loggedInUser;
      newUser!.user.catalogs?.forEach((element) {
        if (element.id == widget.directoryId) {
          element.notes?.removeWhere((element) => element.id == noteID);
          if (mounted) {
            setState(() {
              catalogData = element;
            });
          }
        }
      });
      newUser.user.notes?.forEach((element) {
        element.folder =
            element.folder?.id == widget.directoryId && element.id == noteID
                ? null
                : element.folder;
      });
      loggedInUserProvider.setCurrentUser(newUser);

      notifyToast.show(
        context: context,
        child: const SuccessNotifyToast(title: "Usunięto notatkę z folderu"),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void goToNote(String noteID) {
    final String destination = "/editor/$noteID";

    context.read<DrawerCurrentTabProvider>().setCurrentTab(destination);
    Modular.to.navigate(destination);
  }

  Future<void> assignNote(String nID) async {
    debugPrint("Assign $nID to catalog ${widget.directoryId}");

    try {
      final PatchNoteBodyModel pnbm =
          PatchNoteBodyModel(folderId: widget.directoryId);

      final PatchNoteResponseModel? response = await apiService.patchNote(
        nID,
        pnbm,
        authorizationString,
      );

      LoggedInUser? newUser = loggedInUser;
      if (newUser == null || response == null) return;

      await getCatalogData();

      if (catalogData == null) return;

      newUser.user.notes?.forEach((n) {
        if (n.id == nID) {
          n.folder = CatalogSimple(
            id: catalogData!.id,
            title: catalogData!.title,
            createdAt: catalogData!.createdAt.toString(),
            updatedAt: catalogData!.updatedAt.toString(),
          );
          n.updatedAt = response.note.updatedAt;
        }
      });

      newUser.user.catalogs?.forEach((element) {
        if (element.id == widget.directoryId) {
          element.notes = [
            response.note,
            ...element.notes ?? [],
          ];
        }
      });

      loggedInUserProvider.setCurrentUser(newUser);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final int cardsCount = catalogData?.notes?.length ?? 0;

    List<NoteSimple> notesSorted = cardsCount == 0 ? [] : catalogData!.notes!
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return Scaffold(
      body: GestureDetector(
        onTapDown: (pos) {
          setState(() {
            cursorPosition = pos.localPosition;
          });
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0).copyWith(
              top: Responsive.isDesktop(context) ? 48.0 : 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: newDirectoryNameController,
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() {
                            directoryName = value;
                          });
                          updateCatalogName();
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Title",
                          hintStyle: TextStyle(
                            color: Theme.of(context)
                                .extension<MarkdownNotepadTheme>()
                                ?.text
                                ?.withOpacity(.6),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Ilość notatek: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .extension<MarkdownNotepadTheme>()
                                      ?.text
                                      ?.withOpacity(.6),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .extension<MarkdownNotepadTheme>()
                                      ?.cardColor,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                child: Text(
                                  "$cardsCount",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .extension<MarkdownNotepadTheme>()
                                        ?.text
                                        ?.withOpacity(.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (catalogData?.notes!.isEmpty ?? false)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(4),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(4),
                                  onTap: () => deleteCatalog(),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text("Usuń katalog"),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: cardsCount > 0
                      ? DynamicHeightGridView(
                          shrinkWrap: true,
                          itemCount: cardsCount,
                          crossAxisCount: Responsive.isDesktop(context)
                              ? 3
                              : Responsive.isTablet(context)
                                  ? 2
                                  : 1,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          builder: (BuildContext context, int index) {
                            final NoteSimple noteData = notesSorted[index];

                            return DashboardCard(
                              title: noteData.title,
                              editDate: noteData.updatedAt,
                              isLocalImage: false,
                              backgroundImage:
                                  "https://api.mganczarczyk.pl/tairiku/random/streetmoe?safety=true&seed=${noteData.id}",
                              onLongPress: () {
                                final double dx = cursorPosition.dx -
                                    context
                                        .read<DataDrawerProvider>()
                                        .getDrawerWidth(context);

                                final contextMenu = ContextMenu(
                                  entries: [
                                    const MenuHeader(text: "Opcje"),
                                    MenuItem(
                                      label: 'Przejdź do notatki',
                                      icon: Symbols.navigate_next,
                                      onSelected: () => goToNote(noteData.id),
                                    ),
                                    MenuItem(
                                      label: 'Usuń z folderu',
                                      icon: Symbols.close,
                                      onSelected: () =>
                                          removeFromDirectory(noteData.id),
                                    ),
                                  ],
                                  position: Offset(
                                    dx,
                                    cursorPosition.dy,
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                );
                                contextMenu.show(context);
                              },
                              onTap: () => goToNote(noteData.id),
                            );
                          },
                        )
                      : const DirectoryPageEmpty(),
                ),
                cardsCount > 0
                    ? Center(
                        child: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (builder) =>
                                AssignNoteToCatalogAlertDialog(
                              loggedInUser: loggedInUser,
                              directoryId: widget.directoryId,
                              assignNote: assignNote,
                            ).animate().fadeIn(
                                      duration: 150.ms,
                                    ),
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 4.0),
                            child: Text("Przypisz notatkę do folderu"),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

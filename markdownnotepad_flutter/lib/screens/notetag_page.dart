import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_card.dart';
import 'package:markdownnotepad/components/notetag/notetag_page_empty.dart';
import 'package:markdownnotepad/components/notifications/error_notify_toast.dart';
import 'package:markdownnotepad/components/notifications/success_notify_toast.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/helpers/color_converter.dart';
import 'package:markdownnotepad/helpers/navigation_helper.dart';
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/models/api_models/patch_note_body_model.dart';
import 'package:markdownnotepad/models/api_models/patch_note_tag_body_model.dart';
import 'package:markdownnotepad/models/note_simple.dart';
import 'package:markdownnotepad/models/notetag.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/providers/data_drawer_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class NoteTagPage extends StatefulWidget {
  final String noteTagID;

  const NoteTagPage({
    super.key,
    required this.noteTagID,
  });

  @override
  State<NoteTagPage> createState() => _NoteTagPageState();
}

class _NoteTagPageState extends State<NoteTagPage> {
  final NotifyToast notifyToast = NotifyToast();
  final TextEditingController newNoteTagNameController =
      TextEditingController();

  late String noteTagName;
  late MDNApiService apiService;
  late CurrentLoggedInUserProvider loggedInUserProvider;

  late LoggedInUser? loggedInUser;
  late String authorizationString;

  late NoteTag? noteTagData;

  Offset cursorPosition = Offset.zero;

  @override
  void initState() {
    super.initState();

    MDNDiscordRPC().clearPresence();

    noteTagName = Modular.args.data?['tagName'] as String? ?? '';
    newNoteTagNameController.text = noteTagName;

    loggedInUserProvider = context.read<CurrentLoggedInUserProvider>();
    apiService = context.read<ApiServiceProvider>().apiService;

    loggedInUser = loggedInUserProvider.currentUser;
    authorizationString = "Bearer ${loggedInUser?.accessToken}";

    if (loggedInUser == null) {
      Modular.to.navigate('/auth/login');
      return;
    }

    noteTagData = loggedInUser!.user.tags?.firstWhere(
      (element) => element.id == widget.noteTagID,
    );
    getNoteTagData();
  }

  Future<void> getNoteTagData() async {
    try {
      NoteTag? newNoteTagData = await apiService
          .getNoteTag(
            widget.noteTagID,
            authorizationString,
          )
          ?.then(
            (value) => value.noteTag,
          );

      if (newNoteTagData == null) return;

      if (!mounted) return;

      setState(() {
        noteTagData = newNoteTagData;
      });

      newNoteTagNameController.text = newNoteTagData.title;

      final newUser = loggedInUser;
      newUser!.user.tags?.forEach((element) {
        if (element.id == widget.noteTagID) {
          element = newNoteTagData;
        }
      });
      loggedInUserProvider.setCurrentUser(newUser);
    } on DioException catch (e) {
      NavigationHelper.navigateToPage(
        context,
        "/dashboard/",
      );
      debugPrint(e.toString());
    } catch (e) {
      NavigationHelper.navigateToPage(
        context,
        "/dashboard/",
      );
      debugPrint(e.toString());
    }
  }

  Future<void> patchNoteTag({String? newTitle, Color? newColor}) async {
    if (newTitle == null && newColor == null) return;

    PatchNoteTagBodyModel patchModel = PatchNoteTagBodyModel();

    if (newTitle != null) {
      patchModel.title = newTitle;
    }

    if (newColor != null) {
      patchModel.color = ColorConverter.parseToHex(newColor);
    }

    try {
      final resp = await apiService.patchNoteTag(
        widget.noteTagID,
        patchModel,
        authorizationString,
      );

      if (resp == null) {
        if (!context.mounted) return;
        notifyToast.show(
          context: context,
          child: const ErrorNotifyToast(
            title: "Wystąpił błąd",
            body: "Wystąpił błąd podczas edytowania tagu.",
          ),
        );
        return;
      }

      final newUser = loggedInUser;
      newUser!.user.tags?.forEach((element) {
        if (element.id == widget.noteTagID) {
          element.title = resp.noteTag.title;
          element.color = resp.noteTag.color;
          element.updatedAt = resp.noteTag.updatedAt;
        }
      });
      loggedInUserProvider.setCurrentUser(newUser);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void updateNoteTagName() {
    if (MDNValidator.validateNoteTagTitle(newNoteTagNameController.text) !=
        null) {
      return;
    }

    if (noteTagData?.title == noteTagName) return;

    patchNoteTag(newTitle: newNoteTagNameController.text);
  }

  Future<void> changeNoteTagColor() async {
    await showDialog(
        context: context,
        builder: (context) {
          Color newColor =
              ColorConverter.parseFromHex(noteTagData?.color ?? "#000000");
          Color oldColor =
              ColorConverter.parseFromHex(noteTagData?.color ?? "#000000");

          return AlertDialog(
            title: const Text("Zmień kolor"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  pickerColor: newColor,
                  onColorChanged: (Color value) {
                    newColor = value;
                  },
                  enableAlpha: false,
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
                  if (newColor == oldColor) return;

                  patchNoteTag(newColor: newColor);
                },
                child: const Text("Zapisz"),
              ),
            ],
          );
        });
  }

  Future<void> deleteNoteTag() async {
    try {
      final resp = await apiService.deleteNoteTag(
        widget.noteTagID,
        authorizationString,
      );

      if (resp == null) {
        if (!context.mounted) return;
        notifyToast.show(
          context: context,
          child: const ErrorNotifyToast(
            title: "Wystąpił błąd",
            body: "Wystąpił błąd podczas usuwania tagu.",
          ),
        );
        return;
      }

      final newUser = loggedInUser;
      newUser!.user.tags?.removeWhere(
        (element) => element.id == widget.noteTagID,
      );
      loggedInUserProvider.setCurrentUser(newUser);

      if (!context.mounted) return;
      NavigationHelper.navigateToPage(
        context,
        "/dashboard/",
      );
    } catch (e) {
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Wystąpił błąd",
          body: "Wystąpił błąd podczas usuwania tagu.",
        ),
      );
      debugPrint(e.toString());
    }
  }

  Future<void> removeFromNoteTag(String noteID) async {
    debugPrint(noteID.toString());
    try {
      final PatchNoteBodyModel patchModel = PatchNoteBodyModel(
        tags: loggedInUser?.user.notes
            ?.where((element) => element.id == noteID)
            .first
            .tags
            ?.where((element) => element.id != widget.noteTagID)
            .map((e) => e.id)
            .toList(),
      );
      final resp = await apiService.patchNote(
        noteID,
        patchModel,
        authorizationString,
      );

      if (resp == null) {
        if (!context.mounted) return;
        notifyToast.show(
          context: context,
          child: const ErrorNotifyToast(
            title: "Wystąpił błąd",
            body: "Wystąpił błąd podczas usuwania notatki z tego tagu.",
          ),
        );
        return;
      }

      final newUser = loggedInUser;
      newUser!.user.tags?.forEach((element) {
        if (element.id == widget.noteTagID) {
          element.notes?.removeWhere((element) => element.id == noteID);
          if (mounted) {
            setState(() {
              noteTagData = element;
            });
          }
        }
      });
      newUser.user.notes?.forEach((element) {
        element.folder =
            element.folder?.id == widget.noteTagID && element.id == noteID
                ? null
                : element.folder;
      });
      loggedInUserProvider.setCurrentUser(newUser);

      if (!context.mounted) return;
      notifyToast.show(
        context: context,
        child: const SuccessNotifyToast(title: "Usunięto notatkę z tego tagu"),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void goToNote(String noteID) {
    final String destination = "/editor/$noteID";

    NavigationHelper.navigateToPage(
      context,
      destination,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int cardsCount = noteTagData?.notes?.length ?? 0;

    final List<NoteSimple> notesSorted =
        cardsCount == 0 ? [] : noteTagData!.notes!
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final bool isMobile = Responsive.isMobile(context);

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
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 15.0 : 35.0,
            ).copyWith(
              top: Responsive.isDesktop(context) ? 48.0 : 24.0,
              bottom: 24.0,
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
                        controller: newNoteTagNameController,
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() {
                            noteTagName = value;
                          });
                          updateNoteTagName();
                        },
                        decoration: InputDecoration(
                          isDense: true,
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
                      child: Row(
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
                              vertical: 2,
                              horizontal: 8,
                            ),
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
                    ),
                  ],
                ),
                Row(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(4),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () => changeNoteTagColor(),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text("Zmień kolor tagu"),
                        ),
                      ),
                    ),
                    const Text(" ・ "),
                    Material(
                      borderRadius: BorderRadius.circular(4),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () => deleteNoteTag(),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text("Usuń tag"),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 32.0,
                    bottom: 16.0,
                  ),
                  child: cardsCount > 0
                      ? DynamicHeightGridView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cardsCount,
                          crossAxisCount: Responsive.isDesktop(context)
                              ? 3
                              : Responsive.isTablet(context)
                                  ? 2
                                  : 1,
                          mainAxisSpacing:
                              Responsive.isMobile(context) ? 4 : 16,
                          crossAxisSpacing: 16,
                          builder: (BuildContext context, int index) {
                            final NoteSimple noteData = notesSorted[index];

                            return DashboardCard(
                              title: noteData.title,
                              editDate: noteData.updatedAt,
                              isLocalImage: true,
                              backgroundImage:
                                  "assets/images/img-${Random().nextInt(10) + 1}.jpeg",
                              onLongPress: () {
                                final double dx = cursorPosition.dx -
                                    context
                                        .read<DataDrawerProvider>()
                                        .getDrawerWidth(context);
                                final double dy = cursorPosition.dy -
                                    (isMobile
                                        ? AppBar().preferredSize.height
                                        : 0);

                                final contextMenu = ContextMenu(
                                  entries: [
                                    const MenuHeader(text: "Opcje"),
                                    MenuItem(
                                      label: 'Przejdź do notatki',
                                      icon: Symbols.navigate_next,
                                      onSelected: () => goToNote(noteData.id),
                                    ),
                                    MenuItem(
                                      label: 'Usuń z tagu',
                                      icon: Symbols.close,
                                      onSelected: () =>
                                          removeFromNoteTag(noteData.id),
                                    ),
                                  ],
                                  position: Offset(
                                    dx,
                                    dy,
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                );
                                contextMenu.show(context);
                              },
                              onTap: () => goToNote(noteData.id),
                            );
                          },
                        )
                      : const NoteTagPageEmpty(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

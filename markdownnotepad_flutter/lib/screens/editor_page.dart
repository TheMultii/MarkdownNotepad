// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:highlight/languages/markdown.dart';
import 'package:markdownnotepad/components/alertdialogs/ask_note_client_server_mismatch_action.dart';
import 'package:markdownnotepad/components/editor/editor_desktop_change_tab.dart';
import 'package:markdownnotepad/components/editor/editor_desktop_disable_sidebar.dart';
import 'package:markdownnotepad/components/editor/editor_mobile_top_toolbar.dart';
import 'package:markdownnotepad/components/editor/tabs/editor_tab_editor.dart';
import 'package:markdownnotepad/components/editor/tabs/editor_tab_visual_preview.dart';
import 'package:markdownnotepad/components/notifications/error_notify_toast.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/enums/editor_tabs.dart';
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/models/api_models/patch_note_body_model.dart';
import 'package:markdownnotepad/models/api_responses/get_note_response_model.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class EditorPage extends StatefulWidget {
  final String id;

  const EditorPage({
    super.key,
    required this.id,
  });

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late String noteTitle;
  late CurrentLoggedInUserProvider loggedInUserProvider;
  late LoggedInUser? loggedInUser;
  late MDNApiService apiService;
  late MDNDiscordRPC mdnDiscordRPC;
  late String authorizationString;

  final CodeController controller = CodeController(
    language: markdown,
  );
  final FocusNode fNode = FocusNode();
  final NotifyToast notifyToast = NotifyToast();

  EditorTabs selectedTab = EditorTabs.editor;
  bool isEditorSidebarEnabled = true;
  bool isLiveShareEnabled = false;

  Note? note;
  bool isNoteSafeToEdit = false;

  @override
  void initState() {
    super.initState();

    loggedInUserProvider = context.read<CurrentLoggedInUserProvider>();
    loggedInUser = loggedInUserProvider.currentUser;

    if (loggedInUser == null) {
      Modular.to.navigate('/auth/login');
      return;
    }

    apiService = context.read<ApiServiceProvider>().apiService;

    authorizationString = "Bearer ${loggedInUser!.accessToken}";

    noteTitle = Modular.args.data?['noteTitle'] as String? ?? '';
    // controller.text += '\n\n## ${widget.id}';

    mdnDiscordRPC = MDNDiscordRPC();
    mdnDiscordRPC.setPresence(
      state: "Editing a $noteTitle file",
      forceUpdate: false,
    );

    getInitialData();
  }

  @override
  void dispose() {
    controller.dispose();
    fNode.dispose();
    super.dispose();
  }

  void saveNoteToCache(Note? noteToSave) {
    final toSave = noteToSave ?? note;
    if (toSave == null) return;

    var newUser = loggedInUserProvider.currentUser;
    var userNotes = newUser!.user.notes;

    if (userNotes != null) {
      for (int i = 0; i < userNotes.length; i++) {
        if (userNotes[i].id == widget.id) {
          userNotes[i] = toSave;
          break;
        }
      }
    }

    loggedInUserProvider.setCurrentUser(newUser);
  }

  Future<bool> patchNoteContentToServer({
    required bool forceUpdate,
    String? newTitle,
    String? newContent,
    String? newCatalog,
  }) async {
    if (note == null) return false;

    try {
      final PatchNoteBodyModel body = PatchNoteBodyModel();

      if (newTitle?.isNotEmpty ?? false) {
        body.title = newTitle;
      } else if (forceUpdate) {
        body.title = note!.title;
      }

      if (newContent?.isNotEmpty ?? false) {
        body.content = newContent;
      } else if (forceUpdate) {
        body.content = note!.content;
      }

      if (newCatalog != null) {
        body.folderId = newCatalog;
      }

      if (body.title == null && body.content == null && body.folderId == null) {
        return false;
      }

      final resp = await apiService.patchNote(
        widget.id,
        body,
        authorizationString,
      );

      if (resp != null && mounted) {
        var n = note;
        n!.title = resp.note.title;
        n.content = resp.note.content ?? '';
        n.updatedAt = resp.note.updatedAt;
        n.createdAt = resp.note.createdAt;
        if (body.folderId != null) {
          GetNoteResponseModel? gnrm =
              await apiService.getNote(widget.id, authorizationString);
          if (gnrm != null) {
            n = gnrm.note;
          }
        }

        saveNoteToCache(n);

        /*
        * save cursor caret position before updating note
        * and restore it after updating note
        * so the user can continue editing the note
        * without losing their cursor caret position
        * when the note loses and regains focus again
        */
        final TextEditingValue value = controller.value;
        final int cursorPosition = value.selection.baseOffset;

        setState(() {
          isNoteSafeToEdit = true;
          note = n;
          noteTitle = note!.title;
        });

        if ((newContent?.isNotEmpty ?? false) && forceUpdate) {
          controller.value = value.copyWith(
            text: note!.content,
            selection: TextSelection.fromPosition(
              TextPosition(offset: cursorPosition),
            ),
          );
          fNode.requestFocus();
        }
      }

      return true;
    } on DioException catch (e) {
      debugPrint(e.toString());
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> getInitialData() async {
    try {
      GetNoteResponseModel? gnrm =
          await apiService.getNote(widget.id, authorizationString);

      if (!mounted) return;

      if (gnrm != null) {
        if (note == null || note!.updatedAt == gnrm.note.updatedAt) {
          setState(() {
            isNoteSafeToEdit = true;
            note = gnrm.note;
            noteTitle = note!.title;
            controller.text = note!.content;
          });
        } else {
          isNoteSafeToEdit = false;

          showDialog(
            context: context,
            builder: (context) {
              return AskNoteClientServerMismatchAction(
                cacheLastUpdate: note!.updatedAt,
                serverLastUpdate: gnrm.note.updatedAt,
                overrideNoteFunction: () async {
                  final bool hasSaved = await patchNoteContentToServer(
                    forceUpdate: true,
                  );
                  if (hasSaved) {
                    Navigator.of(context).pop();
                  } else {
                    NotifyToast().show(
                      context: context,
                      child: const ErrorNotifyToast(
                        title:
                            "Błąd podczas nadpisywania notatki w pamięci podręcznej.",
                        body: "Spróbuj ponownie później.",
                      ),
                    );
                  }
                },
                saveNoteToCache: () {
                  saveNoteToCache(gnrm.note);
                  Navigator.of(context).pop();
                  setState(() {
                    isNoteSafeToEdit = true;
                    note = gnrm.note;
                    noteTitle = note!.title;
                    controller.text = note!.content;
                  });
                },
              );
            },
          );
        }
      }

      mdnDiscordRPC.setPresence(
        state: "Editing a $noteTitle file",
        forceUpdate: false,
      );

      final newUser = loggedInUserProvider.currentUser;
      newUser!.user.notes?.forEach((element) {
        if (element.id == widget.id) {
          element = note!;
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

  void onTabChange(EditorTabs tab) => setState(() => selectedTab = tab);

  void toggleEditorSidebar() {
    setState(() {
      isEditorSidebarEnabled = !isEditorSidebarEnabled;
    });
  }

  void toggleLiveShare() {
    setState(() {
      isLiveShareEnabled = !isLiveShareEnabled;
    });
  }

  Future<void> deleteNote() async {
    if (note == null) {
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Wystąpił błąd",
          body: "Nie można usunąć notatki.",
        ),
      );
    }

    try {
      final resp = await apiService.deleteNote(
        note!.id,
        authorizationString,
      );

      if (resp == null) {
        notifyToast.show(
          context: context,
          child: const ErrorNotifyToast(
            title: "Wystąpił błąd",
            body: "Wystąpił błąd podczas usuwania notatki.",
          ),
        );
        return;
      }

      final newUser = loggedInUser;
      newUser!.user.notes?.removeWhere(
        (element) => element.id == note!.id,
      );
      newUser.user.catalogs?.forEach((catalog) {
        catalog.notes?.removeWhere((element) => element.id == note!.id);
      });
      loggedInUserProvider.setCurrentUser(newUser);
      Modular.to.navigate("/dashboard/");
    } catch (e) {
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Wystąpił błąd",
          body: "Wystąpił błąd podczas usuwania notatki.",
        ),
      );
      debugPrint(e.toString());
    }
  }

  Future<void> assignCatalog(String catalogID) async {
    await patchNoteContentToServer(
      newCatalog: catalogID,
      forceUpdate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const double sidebarWidth = 85;

    final MarkdownNotepadTheme? mdnTheme =
        Theme.of(context).extension<MarkdownNotepadTheme>();
    final Color? sidebarColor = mdnTheme?.cardColor?.withOpacity(.25);
    final Color? gutterColor = mdnTheme?.gutterColor;

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: note == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 3.0,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            'Ładowanie...',
                          ),
                        ],
                      )
                        .animate()
                        .fadeIn(
                          duration: 150.ms,
                        )
                        .scale(
                          begin: const Offset(.6, .6),
                          end: const Offset(1.0, 1.0),
                          duration: 150.ms,
                        )
                    : selectedTab == EditorTabs.editor
                        ? EditorTabEditor(
                            controller: controller,
                            focusNode: fNode,
                            sidebarWidth: sidebarWidth,
                            sidebarColor: sidebarColor,
                            gutterColor: gutterColor,
                            editorStyle: a11yDarkTheme,
                            noteTitle: noteTitle,
                            note: note!,
                            isEditorSidebarEnabled:
                                !Responsive.isMobile(context) &&
                                    isEditorSidebarEnabled,
                            isLiveShareEnabled: isLiveShareEnabled,
                            toggleLiveShare: toggleLiveShare,
                            deleteNote: deleteNote,
                            loggedInUser: loggedInUser,
                            assignCatalog: assignCatalog,
                            onNoteTitleChanged: (newTitle) async {
                              if (MDNValidator.validateNoteTitle(newTitle) !=
                                  null) return;

                              await patchNoteContentToServer(
                                forceUpdate: false,
                                newTitle: newTitle,
                              );
                              if (!mounted || note == null) return;

                              var n = note;
                              n!.title = newTitle;

                              setState(() {
                                noteTitle = newTitle;
                                note = n;
                              });
                            },
                            onNoteContentChanged: (newContent) async {
                              await patchNoteContentToServer(
                                forceUpdate: false,
                                newContent: newContent,
                              );
                              if (!mounted || note == null) return;

                              var n = note;
                              n!.content = newContent;

                              setState(() {
                                note = n;
                              });
                            },
                          )
                        : EditorTabVisualPreview(
                            textToRender: controller.fullText,
                            isLiveShareEnabled: isLiveShareEnabled,
                            toggleLiveShare: toggleLiveShare,
                            deleteNote: deleteNote,
                            loggedInUser: loggedInUser,
                            assignCatalog: assignCatalog,
                            noteTitle: noteTitle,
                            note: note!,
                          ),
              ),
            ),
            if (note != null && !Responsive.isMobile(context))
              Container(
                width: 110,
                height: double.infinity,
                color: sidebarColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    EditorDesktopChangeTab(
                      icon: Symbols.edit,
                      text: 'Tryb MD',
                      tab: EditorTabs.editor,
                      currentTab: selectedTab,
                      onTabChange: onTabChange,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    EditorDesktopChangeTab(
                      icon: Symbols.visibility,
                      text: 'Tryb Visual',
                      tab: EditorTabs.visual,
                      currentTab: selectedTab,
                      onTabChange: onTabChange,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 8.0,
                            bottom: 4.0,
                          ),
                          child: Opacity(
                            opacity: .5,
                            child: Divider(),
                          ),
                        ),
                        EditorDesktopDisableSidebar(
                          isEditorOpen: selectedTab == EditorTabs.editor,
                          text:
                              "W${isEditorSidebarEnabled ? 'y' : ''}łącz sidebar",
                          onTap: toggleEditorSidebar,
                        ),
                      ],
                    )
                        .animate(
                          target: selectedTab == EditorTabs.editor ? 1.0 : 0.0,
                        )
                        .fade(duration: 150.ms, begin: 0.0, end: 1.0),
                  ],
                ),
              ),
          ],
        ),
        if (note != null && Responsive.isMobile(context))
          EditorMobileTopToolbar(
            currentTab: selectedTab,
            onTabChange: onTabChange,
          ),
      ],
    );
  }
}

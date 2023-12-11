import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdownnotepad/components/editor/editor_context_menu.dart';
import 'package:markdownnotepad/components/editor/editor_desktop_header.dart';
import 'package:markdownnotepad/components/notifications/info_notify_toast.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/markdown_visual_builder/markdown_preview.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/viewmodels/connected_live_share_user.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

class EditorTabVisualPreview extends StatefulWidget {
  final String noteTitle;
  final Note note;
  final String textToRender;
  final bool isLiveShareEnabled;
  final VoidCallback deleteNote;
  final Function(String) assignCatalog;
  final Function(List<String>) assignNoteTags;
  final LoggedInUser? loggedInUser;
  final Function()? connectToLiveShare;
  final Function()? closeLiveShare;
  final List<ConnectedLiveShareUser> connectedLiveShareUsers;

  const EditorTabVisualPreview({
    super.key,
    required this.noteTitle,
    required this.note,
    required this.textToRender,
    required this.isLiveShareEnabled,
    required this.deleteNote,
    required this.assignCatalog,
    required this.assignNoteTags,
    required this.loggedInUser,
    required this.connectToLiveShare,
    required this.closeLiveShare,
    required this.connectedLiveShareUsers,
  });

  @override
  State<EditorTabVisualPreview> createState() => _EditorTabVisualPreviewState();
}

class _EditorTabVisualPreviewState extends State<EditorTabVisualPreview> {
  final FocusNode noteTitleFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return Focus(
      autofocus: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          isMobile
              ? Container(
                  height: 30,
                  color: Theme.of(context)
                      .extension<MarkdownNotepadTheme>()
                      ?.cardColor
                      ?.withOpacity(.25),
                )
              : const SizedBox(),
          EditorDesktopHeader(
            noteTitle: widget.noteTitle,
            note: widget.note,
            isTitleEditable: false,
            isLiveShareEnabled: widget.isLiveShareEnabled,
            noteTitleFocusNode: noteTitleFocusNode,
            connectToLiveShare: () {
              widget.connectToLiveShare?.call();
            },
            closeLiveShare: () {
              widget.closeLiveShare?.call();
            },
            connectedLiveShareUsers: widget.connectedLiveShareUsers,
            contextMenuOptions: getEditorContextMenu(
              context: context,
              note: widget.note,
              textToRender: widget.textToRender,
              isLiveShareEnabled: widget.isLiveShareEnabled,
              deleteNote: widget.deleteNote,
              loggedInUser: widget.loggedInUser,
              assignCatalog: widget.assignCatalog,
              assignNoteTags: widget.assignNoteTags,
              changeNoteName: () => FocusScope.of(context).requestFocus(
                noteTitleFocusNode,
              ),
              connectToLiveShare: () {
                widget.connectToLiveShare?.call();
              },
              closeLiveShare: () {
                widget.closeLiveShare?.call();
              },
            ),
            contextMenuShortcuts: {
              LogicalKeySet(
                      LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                  () async {
                NotifyToast().show(
                  context: context,
                  child: const InfoNotifyToast(
                    title: 'Aplikacja automatycznie zapisuje zmiany',
                    body: 'Nie ma potrzeby ręcznego zapisywania zmian,',
                  ),
                );
              },
            },
          ),
          Expanded(
            child: MarkdownPreview(
              textToRender: widget.textToRender,
            ),
          ),
        ],
      ),
    );
  }
}

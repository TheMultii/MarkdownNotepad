import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdownnotepad/components/editor/editor_context_menu.dart';
import 'package:markdownnotepad/components/editor/editor_desktop_header.dart';
import 'package:markdownnotepad/components/notifications/info_notify_toast.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/markdown_visual_builder/markdown_preview.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

class EditorTabVisualPreview extends StatefulWidget {
  final String noteTitle;
  final Note note;
  final String textToRender;
  final bool isLiveShareEnabled;
  final VoidCallback toggleLiveShare;
  final VoidCallback deleteNote;
  final Function(String) assignCatalog;
  final LoggedInUser? loggedInUser;

  const EditorTabVisualPreview({
    super.key,
    required this.noteTitle,
    required this.note,
    required this.textToRender,
    required this.isLiveShareEnabled,
    required this.toggleLiveShare,
    required this.deleteNote,
    required this.assignCatalog,
    required this.loggedInUser,
  });

  @override
  State<EditorTabVisualPreview> createState() => _EditorTabVisualPreviewState();
}

class _EditorTabVisualPreviewState extends State<EditorTabVisualPreview> {
  @override
  Widget build(BuildContext context) {
    final FocusNode noteTitleFocusNode = FocusNode();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        EditorDesktopHeader(
          noteTitle: widget.noteTitle,
          note: widget.note,
          isTitleEditable: false,
          isLiveShareEnabled: widget.isLiveShareEnabled,
          toggleLiveShare: widget.toggleLiveShare,
          noteTitleFocusNode: noteTitleFocusNode,
          contextMenuOptions: getEditorContextMenu(
            context: context,
            note: widget.note,
            textToRender: widget.textToRender,
            isLiveShareEnabled: widget.isLiveShareEnabled,
            toggleLiveShare: widget.toggleLiveShare,
            deleteNote: widget.deleteNote,
            loggedInUser: widget.loggedInUser,
            assignCatalog: widget.assignCatalog,
            changeNoteName: () => FocusScope.of(context).requestFocus(
              noteTitleFocusNode,
            ),
          ),
          contextMenuShortcuts: {
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
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
    );
  }
}

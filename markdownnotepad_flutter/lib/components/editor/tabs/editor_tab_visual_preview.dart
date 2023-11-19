import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdownnotepad/components/editor/editor_context_menu.dart';
import 'package:markdownnotepad/components/editor/editor_desktop_header.dart';
import 'package:markdownnotepad/components/notifications/info_notify_toast.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/markdown_visual_builder/markdown_preview.dart';

class EditorTabVisualPreview extends StatefulWidget {
  final String noteID;
  final String textToRender;
  final bool isLiveShareEnabled;
  final VoidCallback toggleLiveShare;

  const EditorTabVisualPreview({
    super.key,
    required this.noteID,
    required this.textToRender,
    required this.isLiveShareEnabled,
    required this.toggleLiveShare,
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
          isTitleEditable: false,
          isLiveShareEnabled: widget.isLiveShareEnabled,
          toggleLiveShare: widget.toggleLiveShare,
          noteTitleFocusNode: noteTitleFocusNode,
          contextMenuOptions: getEditorContextMenu(
            context: context,
            noteID: widget.noteID,
            textToRender: widget.textToRender,
            isLiveShareEnabled: widget.isLiveShareEnabled,
            toggleLiveShare: widget.toggleLiveShare,
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

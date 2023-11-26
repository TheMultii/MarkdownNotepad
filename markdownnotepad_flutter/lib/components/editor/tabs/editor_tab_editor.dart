import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:markdownnotepad/components/editor/editor_context_menu.dart';
import 'package:markdownnotepad/components/editor/editor_desktop_header.dart';
import 'package:markdownnotepad/components/editor/editor_page_live_share_user_small_avatar.dart';
import 'package:markdownnotepad/components/notifications/info_notify_toast.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

class EditorTabEditor extends StatefulWidget {
  final String noteTitle;
  final Note note;
  final CodeController controller;
  final FocusNode focusNode;
  final double sidebarWidth;
  final Color? sidebarColor;
  final Color? gutterColor;
  final Map<String, TextStyle> editorStyle;
  final bool isEditorSidebarEnabled;
  final bool isLiveShareEnabled;
  final VoidCallback toggleLiveShare;
  final Function(String)? onNoteTitleChanged;
  final Function(String)? onNoteContentChanged;
  final VoidCallback deleteNote;
  final Function(String) assignCatalog;
  final Function(List<String>) assignNoteTags;
  final LoggedInUser? loggedInUser;

  const EditorTabEditor({
    super.key,
    required this.noteTitle,
    required this.note,
    required this.controller,
    required this.focusNode,
    required this.sidebarWidth,
    required this.sidebarColor,
    required this.gutterColor,
    required this.editorStyle,
    required this.isEditorSidebarEnabled,
    required this.isLiveShareEnabled,
    required this.toggleLiveShare,
    required this.deleteNote,
    required this.assignCatalog,
    required this.assignNoteTags,
    required this.loggedInUser,
    this.onNoteTitleChanged,
    this.onNoteContentChanged,
  });

  @override
  State<EditorTabEditor> createState() => _EditorTabEditorState();
}

class _EditorTabEditorState extends State<EditorTabEditor> {
  final FocusNode noteTitleFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Responsive.isMobile(context)
          ? const EdgeInsets.only(top: 40)
          : EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          EditorDesktopHeader(
            noteTitle: widget.noteTitle,
            note: widget.note,
            isLiveShareEnabled: widget.isLiveShareEnabled,
            toggleLiveShare: widget.toggleLiveShare,
            noteTitleFocusNode: noteTitleFocusNode,
            onNoteTitleChanged: widget.onNoteTitleChanged,
            contextMenuOptions: getEditorContextMenu(
              context: context,
              note: widget.note,
              textToRender: widget.controller.text,
              isLiveShareEnabled: widget.isLiveShareEnabled,
              deleteNote: widget.deleteNote,
              assignCatalog: widget.assignCatalog,
              assignNoteTags: widget.assignNoteTags,
              loggedInUser: widget.loggedInUser,
              toggleLiveShare: widget.toggleLiveShare,
              changeNoteName: () => FocusScope.of(context).requestFocus(
                noteTitleFocusNode,
              ),
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
            child: Stack(
              children: [
                if (!Responsive.isMobile(context) &&
                    widget.isEditorSidebarEnabled)
                  Container(
                    width: widget.sidebarWidth,
                    height: double.infinity,
                    color: widget.sidebarColor,
                  ),
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      widget.focusNode.requestFocus();
                    },
                  ),
                ),
                CodeTheme(
                  data: CodeThemeData(
                    styles: {
                      ...widget.editorStyle,
                      'root': TextStyle(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        color: const Color(0xfff8f8f2),
                      ),
                      'title': TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      'section': TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    },
                  ),
                  child: SingleChildScrollView(
                    child: CodeField(
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      wrap: true,
                      separateGutterFromEditor: true,
                      onChanged: (newContent) async {
                        final String registeredValue = widget.controller.text;
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (widget.onNoteContentChanged != null &&
                              registeredValue == widget.controller.text) {
                            widget.onNoteContentChanged!(newContent);
                          }
                        });
                      },
                      gutterStyle: GutterStyle(
                        width: widget.sidebarWidth,
                        margin: 0,
                        textAlign: TextAlign.right,
                        background: widget.gutterColor,
                        showErrors: widget.isEditorSidebarEnabled,
                        showFoldingHandles: widget.isEditorSidebarEnabled,
                        showLineNumbers: widget.isEditorSidebarEnabled,
                      ),
                      lineNumberBuilder: (index, style) {
                        final int lineNumber = index + 1;
                        style?.apply(
                          color: widget.sidebarColor,
                        );

                        return TextSpan(
                          children: [
                            if (lineNumber % 100 == 0)
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 2.0),
                                  child: EditorPageLiveShareUserSmallAvatar(
                                    lineNumber: lineNumber,
                                    onTap: () {
                                      debugPrint('$lineNumber tapped');
                                    },
                                  ),
                                ),
                              ),
                            TextSpan(
                              text: "$lineNumber",
                            ),
                          ],
                          style: style,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

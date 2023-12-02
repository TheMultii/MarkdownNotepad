import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:markdownnotepad/components/editor/editor_context_menu.dart';
import 'package:markdownnotepad/components/editor/editor_desktop_header.dart';
import 'package:markdownnotepad/components/editor/editor_page_live_share_user_small_avatar.dart';
import 'package:markdownnotepad/components/notifications/info_notify_toast.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/intents/editor_shortcuts.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/viewmodels/connected_live_share_user.dart';
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
  final Function(String)? onNoteTitleChanged;
  final Function(String)? onNoteContentChanged;
  final VoidCallback deleteNote;
  final Function(String) assignCatalog;
  final Function(List<String>) assignNoteTags;
  final LoggedInUser? loggedInUser;
  final Function()? connectToLiveShare;
  final Function()? closeLiveShare;
  final List<ConnectedLiveShareUser> connectedLiveShareUsers;

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
    required this.deleteNote,
    required this.assignCatalog,
    required this.assignNoteTags,
    required this.loggedInUser,
    required this.connectedLiveShareUsers,
    this.connectToLiveShare,
    this.closeLiveShare,
    this.onNoteTitleChanged,
    this.onNoteContentChanged,
  });

  @override
  State<EditorTabEditor> createState() => _EditorTabEditorState();
}

class _EditorTabEditorState extends State<EditorTabEditor> {
  final FocusNode noteTitleFocusNode = FocusNode();

  int getLineNumber() {
    final cursorPosition = widget.controller.selection.baseOffset;
    final text = widget.controller.text;

    if (cursorPosition == 0) return 0;

    int line = 0;
    for (int i = 0; i < cursorPosition; i++) {
      if (text[i] == '\n') {
        line++;
      }
    }

    return line;
  }

  void changeLineIndentation(
    int lineNumber,
    String intentName,
  ) {
    final int ctrlIntentName =
        int.tryParse(intentName.replaceAll("Ctrl", "")) ?? -1;
    if (ctrlIntentName == -1) return;

    final String text = widget.controller.text;
    final List<String> lines = text.split('\n');
    final String line = lines[lineNumber];
    final int oldCaretPosition = widget.controller.selection.baseOffset;

    int amountOfHashes = 0;
    for (int i = 0; i < line.length; i++) {
      if (line[i] == '#') {
        amountOfHashes++;
      } else {
        break;
      }
    }

    String newLine = line.replaceFirst("${'#' * amountOfHashes} ", "");
    bool shouldAddNewHashes = true;

    if (ctrlIntentName == amountOfHashes) {
      shouldAddNewHashes = false;
    }

    if (shouldAddNewHashes) {
      newLine = "${'#' * ctrlIntentName} $newLine";
    }

    lines[lineNumber] = newLine;

    final String newContent = lines.join('\n');
    widget.controller.text = newContent;

    int newCaretPosition = oldCaretPosition + (newContent.length - text.length);
    if (newCaretPosition < 0) newCaretPosition = 0;

    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(
        offset: oldCaretPosition + (newContent.length - text.length),
      ),
    );

    widget.onNoteContentChanged!(newContent);
  }

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
            connectToLiveShare: () {
              widget.connectToLiveShare?.call();
            },
            closeLiveShare: () {
              widget.closeLiveShare?.call();
            },
            noteTitleFocusNode: noteTitleFocusNode,
            onNoteTitleChanged: widget.onNoteTitleChanged,
            connectedLiveShareUsers: widget.connectedLiveShareUsers,
            contextMenuOptions: getEditorContextMenu(
              context: context,
              note: widget.note,
              textToRender: widget.controller.text,
              isLiveShareEnabled: widget.isLiveShareEnabled,
              deleteNote: widget.deleteNote,
              assignCatalog: widget.assignCatalog,
              assignNoteTags: widget.assignNoteTags,
              loggedInUser: widget.loggedInUser,
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
                    child: MDNEditorIntent(
                      invokeFunction: (Intent intent) {
                        final String intentName = intent.runtimeType
                            .toString()
                            .replaceAll('Intent', '')
                            .replaceAll('Editor', '');

                        if (!widget.focusNode.hasFocus) return;

                        changeLineIndentation(
                          getLineNumber(),
                          intentName,
                        );
                      },
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
                              if (widget.connectedLiveShareUsers.any(
                                  (user) => user.currentLine == lineNumber))
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 5.0,
                                    ),
                                    child: EditorPageLiveShareUserSmallAvatar(
                                      user: widget.connectedLiveShareUsers
                                          .firstWhere((user) =>
                                              user.currentLine == lineNumber),
                                    ),
                                  ),
                                ),
                              WidgetSpan(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Text('$lineNumber'),
                                ),
                              ),
                            ],
                            style: style,
                          );
                        },
                      ),
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

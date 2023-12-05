import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:markdownnotepad/components/editor/editor_desktop_header_list_item.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/helpers/date_helper.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/providers/data_drawer_provider.dart';
import 'package:markdownnotepad/viewmodels/connected_live_share_user.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class EditorDesktopHeader extends StatefulWidget {
  final String noteTitle;
  final Note note;
  final bool isTitleEditable;
  final bool isLiveShareEnabled;
  final VoidCallback connectToLiveShare;
  final VoidCallback closeLiveShare;
  final List<ContextMenuEntry> contextMenuOptions;
  final Map<ShortcutActivator, void Function()>? contextMenuShortcuts;
  final FocusNode noteTitleFocusNode;
  final Function(String)? onNoteTitleChanged;
  final List<ConnectedLiveShareUser> connectedLiveShareUsers;

  const EditorDesktopHeader({
    super.key,
    required this.noteTitle,
    required this.note,
    this.isTitleEditable = true,
    required this.isLiveShareEnabled,
    required this.connectToLiveShare,
    required this.closeLiveShare,
    this.contextMenuOptions = const [],
    this.contextMenuShortcuts,
    required this.noteTitleFocusNode,
    this.onNoteTitleChanged,
    required this.connectedLiveShareUsers,
  });

  @override
  State<EditorDesktopHeader> createState() => _EditorDesktopHeaderState();
}

class _EditorDesktopHeaderState extends State<EditorDesktopHeader> {
  final TextEditingController noteTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    noteTitleController.text = widget.noteTitle;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Container(
      color: Theme.of(context)
          .extension<MarkdownNotepadTheme>()
          ?.cardColor
          ?.withOpacity(.25),
      padding: EdgeInsets.only(
        top: 16,
        left: isMobile ? 16 : 32,
        right: 16,
        bottom: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: noteTitleController,
                  focusNode: widget.noteTitleFocusNode,
                  readOnly: !widget.isTitleEditable,
                  maxLines: 1,
                  onFieldSubmitted: widget.onNoteTitleChanged == null
                      ? null
                      : (value) => widget.onNoteTitleChanged!(value),
                  onChanged: (newTitle) {
                    final String registeredValue = noteTitleController.text;
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (widget.onNoteTitleChanged != null &&
                          registeredValue == noteTitleController.text) {
                        widget.onNoteTitleChanged!(newTitle);
                      }
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tytuł notatki",
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
              InkWell(
                borderRadius: BorderRadius.circular(9999),
                onTap: () {
                  if (widget.isLiveShareEnabled) {
                    widget.closeLiveShare();
                  } else {
                    widget.connectToLiveShare();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    widget.isLiveShareEnabled
                        ? Symbols.share_off
                        : Symbols.share,
                    size: 20,
                    color: Theme.of(context)
                        .extension<MarkdownNotepadTheme>()
                        ?.text
                        ?.withOpacity(.6),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(9999),
                onTapDown: (pos) {
                  if (widget.contextMenuOptions.isEmpty) {
                    return;
                  }

                  final double dx = pos.globalPosition.dx -
                      200 -
                      (context
                              .read<DataDrawerProvider>()
                              .getDrawerWidth(context) *
                          2);

                  final double dy = pos.globalPosition.dy -
                      (isMobile ? AppBar().preferredSize.height * 1.8 : 0);

                  final contextMenu = ContextMenu(
                    entries: widget.contextMenuOptions,
                    position: Offset(
                      dx,
                      dy,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    shortcuts: widget.contextMenuShortcuts,
                  );

                  showContextMenu(context, contextMenu: contextMenu);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context)
                        .extension<MarkdownNotepadTheme>()
                        ?.text
                        ?.withOpacity(.6),
                  ),
                ),
              )
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EditorDesktopHeaderListItem(
                  icon: FeatherIcons.calendar,
                  title: 'Data stworzenia',
                  value: DateHelper.getFormattedDate(widget.note.createdAt),
                ),
                EditorDesktopHeaderListItem(
                  icon: FeatherIcons.folder,
                  title: 'Folder',
                  value: widget.note.folder?.title ?? 'Brak',
                  isItalic: widget.note.folder == null,
                ),
                EditorDesktopHeaderListItem(
                  icon: FeatherIcons.users,
                  title: 'Kolaboracja',
                  value:
                      'W${widget.isLiveShareEnabled ? '' : 'y'}łączona${widget.connectedLiveShareUsers.isNotEmpty ? ' (${widget.connectedLiveShareUsers.length})' : ''}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

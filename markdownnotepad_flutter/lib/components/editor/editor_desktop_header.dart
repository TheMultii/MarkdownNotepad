import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:markdownnotepad/components/editor/editor_desktop_header_list_item.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class EditorDesktopHeader extends StatefulWidget {
  final bool isTitleEditable;
  final bool isLiveShareEnabled;
  final VoidCallback toggleLiveShare;
  final List<ContextMenuEntry> contextMenuOptions;
  final Map<ShortcutActivator, void Function()>? contextMenuShortcuts;
  final FocusNode noteTitleFocusNode;

  const EditorDesktopHeader({
    super.key,
    this.isTitleEditable = true,
    required this.isLiveShareEnabled,
    required this.toggleLiveShare,
    this.contextMenuOptions = const [],
    this.contextMenuShortcuts,
    required this.noteTitleFocusNode,
  });

  @override
  State<EditorDesktopHeader> createState() => _EditorDesktopHeaderState();
}

class _EditorDesktopHeaderState extends State<EditorDesktopHeader> {
  Offset cursorPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context)
          .extension<MarkdownNotepadTheme>()
          ?.cardColor
          ?.withOpacity(.25),
      padding: const EdgeInsets.only(
        top: 16,
        left: 32,
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
                  focusNode: widget.noteTitleFocusNode,
                  initialValue: "Lorem ipsum",
                  readOnly: !widget.isTitleEditable,
                  maxLines: 1,
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
              IconButton(
                onPressed: () => widget.toggleLiveShare(),
                icon: Icon(
                  widget.isLiveShareEnabled
                      ? Icons.pause_outlined
                      : Icons.play_arrow_outlined,
                  color: Theme.of(context)
                      .extension<MarkdownNotepadTheme>()
                      ?.text
                      ?.withOpacity(.6),
                ),
              ),
              MouseRegion(
                onHover: (event) {
                  setState(() {
                    cursorPosition = event.position;
                  });
                },
                child: IconButton(
                  onPressed: () {
                    if (widget.contextMenuOptions.isEmpty) {
                      return;
                    }
                    final contextMenu = ContextMenu(
                      entries: widget.contextMenuOptions,
                      position: Offset(
                        cursorPosition.dx / 2 - 200,
                        cursorPosition.dy,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      shortcuts: widget.contextMenuShortcuts,
                    );

                    showContextMenu(context, contextMenu: contextMenu);
                  },
                  icon: Icon(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const EditorDesktopHeaderListItem(
                icon: FeatherIcons.calendar,
                title: 'Data stworzenia',
                value: '23.10.2023',
              ),
              const EditorDesktopHeaderListItem(
                icon: FeatherIcons.folder,
                title: 'Folder',
                value: 'Folder 1',
              ),
              EditorDesktopHeaderListItem(
                icon: FeatherIcons.users,
                title: 'Kolaboracja',
                value: 'W${widget.isLiveShareEnabled ? '' : 'y'}łączona',
              ),
            ],
          ),
          // const Divider(),
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [],
          // ),
          // const Divider(),
        ],
      ),
    );
  }
}

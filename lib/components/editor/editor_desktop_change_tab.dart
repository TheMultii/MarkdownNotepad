import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/enums/editor_tabs.dart';

class EditorDesktopChangeTab extends StatefulWidget {
  final IconData icon;
  final String text;
  final EditorTabs tab;
  final EditorTabs currentTab;
  final void Function(EditorTabs) onTabChange;

  const EditorDesktopChangeTab({
    super.key,
    required this.icon,
    required this.text,
    required this.tab,
    required this.currentTab,
    required this.onTabChange,
  });

  @override
  State<EditorDesktopChangeTab> createState() => _EditorDesktopChangeTabState();
}

class _EditorDesktopChangeTabState extends State<EditorDesktopChangeTab> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final MarkdownNotepadTheme? theme =
        Theme.of(context).extension<MarkdownNotepadTheme>();
    final bool isSelected = widget.currentTab == widget.tab;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => widget.onTabChange(widget.tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: isSelected
                ? theme?.text?.withOpacity(.15)
                : isHovered
                    ? theme?.text?.withOpacity(.1)
                    : theme?.text?.withOpacity(.05),
            border: Border.all(
              width: 2,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : theme?.text?.withOpacity(.6) ??
                      Colors.white.withOpacity(.6),
            ),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: theme?.text?.withOpacity(isSelected ? 1 : .6),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme?.text?.withOpacity(isSelected ? 1 : .6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

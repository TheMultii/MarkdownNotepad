import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class EditorDesktopDisableSidebar extends StatefulWidget {
  final String text;
  final void Function() onTap;
  final bool isEditorOpen;

  const EditorDesktopDisableSidebar({
    super.key,
    required this.text,
    required this.onTap,
    required this.isEditorOpen,
  });

  @override
  State<EditorDesktopDisableSidebar> createState() =>
      _EditorDesktopDisableSidebarState();
}

class _EditorDesktopDisableSidebarState
    extends State<EditorDesktopDisableSidebar> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final MarkdownNotepadTheme? theme =
        Theme.of(context).extension<MarkdownNotepadTheme>();

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
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: widget.isEditorOpen ? () => widget.onTap() : null,
        mouseCursor: widget.isEditorOpen
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: isHovered
                ? theme?.text?.withOpacity(.1)
                : theme?.text?.withOpacity(.05),
            border: Border.all(
              width: 2,
              color:
                  theme?.text?.withOpacity(.6) ?? Colors.white.withOpacity(.6),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme?.text?.withOpacity(.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

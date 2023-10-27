import 'package:flutter/material.dart';
import 'package:markdownnotepad/enums/editor_tabs.dart';

class EditorMobileHoverButton extends StatefulWidget {
  final String text;
  final EditorTabs tab;
  final EditorTabs currentTab;
  final Function() onSelect;

  const EditorMobileHoverButton({
    super.key,
    required this.text,
    required this.tab,
    required this.currentTab,
    required this.onSelect,
  });

  @override
  State<EditorMobileHoverButton> createState() =>
      _EditorMobileHoverButtonState();
}

class _EditorMobileHoverButtonState extends State<EditorMobileHoverButton> {
  bool isHovered = false;
  final Color selectedColor = const Color(0x66303030);

  @override
  Widget build(BuildContext context) {
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
      child: GestureDetector(
        onTap: () => widget.onSelect(),
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: widget.tab == widget.currentTab || isHovered
                ? selectedColor
                : Colors.transparent,
          ),
          duration: const Duration(milliseconds: 150),
          child: Text(widget.text),
        ),
      ),
    );
  }
}

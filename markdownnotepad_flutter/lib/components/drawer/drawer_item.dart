import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class MDNDrawerItem extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;
  final IconData icon;
  final double? iconFill;
  final Color? iconColor;

  const MDNDrawerItem({
    super.key,
    required this.title,
    required this.onPressed,
    required this.isSelected,
    required this.icon,
    this.iconFill = 0,
    this.iconColor,
  });

  @override
  State<MDNDrawerItem> createState() => _MDNDrawerItemState();
}

class _MDNDrawerItemState extends State<MDNDrawerItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        Theme.of(context).extension<MarkdownNotepadTheme>()!.text!;
    return AnimatedContainer(
      color: widget.isSelected
          ? Theme.of(context).colorScheme.primary
          : isHovered
              ? Colors.white.withOpacity(.05)
              : Colors.transparent,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      child: InkWell(
        splashColor: Colors.white.withOpacity(.05),
        hoverColor: Colors.transparent,
        onTap: widget.onPressed,
        child: MouseRegion(
          onEnter: (event) => setState(() => isHovered = true),
          onExit: (event) => setState(() => isHovered = false),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 20.0,
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 18,
                  fill: widget.iconFill,
                  color: widget.isSelected || isHovered
                      ? (widget.iconColor ?? textColor)
                      : (widget.iconColor ?? textColor).withOpacity(.7),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: widget.isSelected || isHovered
                          ? textColor
                          : textColor.withOpacity(.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
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

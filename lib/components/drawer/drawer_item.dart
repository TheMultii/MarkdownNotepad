import 'package:flutter/material.dart';

class MDNDrawerItem extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;
  final IconData icon;

  const MDNDrawerItem({
    super.key,
    required this.title,
    required this.onPressed,
    required this.isSelected,
    required this.icon,
  });

  @override
  State<MDNDrawerItem> createState() => _MDNDrawerItemState();
}

class _MDNDrawerItemState extends State<MDNDrawerItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
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
          onHover: (event) => setState(() => isHovered = true),
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
                  color: widget.isSelected || isHovered
                      ? Colors.white
                      : Colors.white70,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: widget.isSelected || isHovered
                          ? Colors.white
                          : Colors.white70,
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

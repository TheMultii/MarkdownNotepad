import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.textOpacity = 1.0,
    this.isItalic = false,
    this.selected = false,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isItalic, selected;
  final double textOpacity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor:
          selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
      leading: Icon(
        icon,
        color: Colors.white.withOpacity(textOpacity),
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(textOpacity),
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          fontSize: 13,
        ),
      ),
      onTap: onTap,
    );
  }
}

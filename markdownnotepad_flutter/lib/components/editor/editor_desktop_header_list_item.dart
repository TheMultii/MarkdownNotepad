import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class EditorDesktopHeaderListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const EditorDesktopHeaderListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final MarkdownNotepadTheme? theme =
        Theme.of(context).extension<MarkdownNotepadTheme>();

    return Padding(
      padding: const EdgeInsets.only(right: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme?.text?.withOpacity(.6),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme?.text?.withOpacity(.6),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

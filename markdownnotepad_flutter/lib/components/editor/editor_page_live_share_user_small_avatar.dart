import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class EditorPageLiveShareUserSmallAvatar extends StatelessWidget {
  final int lineNumber;
  final void Function() onTap;

  const EditorPageLiveShareUserSmallAvatar({
    super.key,
    required this.lineNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final MarkdownNotepadTheme? theme =
        Theme.of(context).extension<MarkdownNotepadTheme>();

    return Tooltip(
      message:
          "https://api.mganczarczyk.pl/tairiku/random/streetmoe?safety=true&seed=${lineNumber % 5}",
      excludeFromSemantics: true,
      waitDuration: const Duration(
        milliseconds: 60,
      ),
      decoration: BoxDecoration(
        color: theme?.cardColor,
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: TextStyle(
        color: theme?.text,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onTap(),
          child: ClipOval(
            child: Image.network(
              "https://api.mganczarczyk.pl/tairiku/random/streetmoe?safety=true&seed=${lineNumber % 5}",
              width: 18,
              height: 18,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

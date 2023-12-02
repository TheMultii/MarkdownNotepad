import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/viewmodels/connected_live_share_user.dart';

class EditorPageLiveShareUserSmallAvatar extends StatelessWidget {
  final ConnectedLiveShareUser user;
  final void Function()? onTap;

  const EditorPageLiveShareUserSmallAvatar({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final MarkdownNotepadTheme? theme =
        Theme.of(context).extension<MarkdownNotepadTheme>();

    return Tooltip(
      message: user.username,
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
        cursor:
            onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap == null ? null : () => onTap!(),
          child: ClipOval(
            child: Image.network(
              "http://localhost:3000/avatar/${user.id}",
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

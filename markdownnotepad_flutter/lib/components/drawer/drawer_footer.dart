import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/avatar_with_status.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class MDNDrawerFooter extends StatelessWidget {
  final String avatarUrl;
  final String username;

  const MDNDrawerFooter({
    super.key,
    required this.avatarUrl,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarWithStatus(
            colorStatus: Colors.green,
            borderColor: Theme.of(context)
                .extension<MarkdownNotepadTheme>()
                ?.drawerBackground,
            statusSize: 13,
            child: ClipOval(
              child: Image.network(
                avatarUrl,
                width: 38,
                height: 38,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              username,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

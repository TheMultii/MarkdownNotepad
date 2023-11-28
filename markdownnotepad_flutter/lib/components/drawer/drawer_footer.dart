import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/components/avatar_with_status.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:provider/provider.dart';

class MDNDrawerFooter extends StatelessWidget {
  const MDNDrawerFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentLoggedInUserProvider>(
        builder: (context, notifier, child) {
      if (notifier.currentUser == null) {
        Modular.to.navigate('/auth/login');
        return const SizedBox.shrink();
      }

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
                child: CachedNetworkImage(
                  imageUrl: notifier.avatarUrl,
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(
                    strokeWidth: 3.0,
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                notifier.currentUser!.user.name.isNotEmpty
                    ? "${notifier.currentUser!.user.name} ${notifier.currentUser!.user.surname}"
                    : notifier.currentUser!.user.username,
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
    });
  }
}

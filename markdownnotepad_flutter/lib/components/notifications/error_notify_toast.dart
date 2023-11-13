import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class ErrorNotifyToast extends StatelessWidget {
  final String title;
  final String? body;
  final TextStyle? titleTextStyle;
  final TextStyle? bodyTextStyle;
  final double minWidth;
  final double minHeight;

  const ErrorNotifyToast({
    super.key,
    required this.title,
    this.body,
    this.titleTextStyle,
    this.bodyTextStyle,
    this.minWidth = 200,
    this.minHeight = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: minWidth,
        minHeight: minHeight,
      ),
      padding: const EdgeInsets.all(
        10,
      ),
      margin: const EdgeInsets.only(
        top: 8.0,
        right: 8.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<MarkdownNotepadTheme>()?.cardColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleTextStyle ??
                const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
          ),
          if (body != null)
            Text(
              body!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: bodyTextStyle ??
                  TextStyle(
                    color: Theme.of(context)
                        .extension<MarkdownNotepadTheme>()
                        ?.text
                        ?.withOpacity(.6),
                    fontSize: 12,
                  ),
            ),
        ],
      ),
    );
  }
}

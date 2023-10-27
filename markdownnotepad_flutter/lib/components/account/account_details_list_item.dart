import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class AccountDetailsListItem extends StatelessWidget {
  final String title;
  final String value;
  final EdgeInsets padding;

  const AccountDetailsListItem({
    super.key,
    required this.title,
    required this.value,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.0,
              color: Theme.of(context)
                  .extension<MarkdownNotepadTheme>()
                  ?.text!
                  .withOpacity(.6),
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context)
                  .extension<MarkdownNotepadTheme>()
                  ?.text!
                  .withOpacity(.6),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

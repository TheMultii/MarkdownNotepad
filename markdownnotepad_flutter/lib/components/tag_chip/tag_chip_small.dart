import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class TagChipSmall extends StatelessWidget {
  final String tag;
  final List<String> tags;
  final Color chipColor;

  const TagChipSmall({
    super.key,
    required this.tag,
    required this.tags,
    required this.chipColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: tags.last != tag ? 5.0 : 0,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context)
                .extension<MarkdownNotepadTheme>()!
                .text!
                .withOpacity(.4),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  width: 8,
                  height: 8,
                  color: chipColor,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                tag,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

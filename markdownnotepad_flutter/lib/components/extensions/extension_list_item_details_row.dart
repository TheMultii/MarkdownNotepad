import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/viewmodels/extension.dart';

class ExtensionListItemDetailsRow extends StatelessWidget {
  const ExtensionListItemDetailsRow({
    super.key,
    required this.extension,
  });

  final MDNExtension extension;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                extension.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 14,
                ),
              ),
              Text(
                "${extension.author} ・ ${extension.version}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Theme.of(context)
                      .extension<MarkdownNotepadTheme>()
                      ?.text
                      ?.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

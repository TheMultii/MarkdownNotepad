import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class DirectoryPageEmpty extends StatelessWidget {
  const DirectoryPageEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final Color? textColor = Theme.of(context)
        .extension<MarkdownNotepadTheme>()
        ?.text
        ?.withOpacity(.6);

    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/Clipboard.png"),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: "Brak notatek w folderze\n",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "Nic nie szkodzi! Po prostu stwórz kolejną notatkę.",
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class SampleNotifyToast extends StatelessWidget {
  const SampleNotifyToast({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 75,
      padding: const EdgeInsets.only(
        left: 10,
        top: 10,
        bottom: 10,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 10,
            ),
            child: ClipOval(
              child: Image.network(
                "https://api.mganczarczyk.pl/tairiku/ai/streetmoe?safety=true",
                width: 37,
                height: 37,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "test",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "owo",
                  style: TextStyle(
                    color: Theme.of(context)
                        .extension<MarkdownNotepadTheme>()
                        ?.text
                        ?.withOpacity(.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

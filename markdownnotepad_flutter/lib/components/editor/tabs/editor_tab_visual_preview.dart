import 'package:flutter/material.dart';
import 'package:markdownnotepad/markdown_visual_builder/markdown_preview.dart';

class EditorTabVisualPreview extends StatefulWidget {
  final String textToRender;

  const EditorTabVisualPreview({
    super.key,
    required this.textToRender,
  });

  @override
  State<EditorTabVisualPreview> createState() => _EditorTabVisualPreviewState();
}

class _EditorTabVisualPreviewState extends State<EditorTabVisualPreview> {
  @override
  Widget build(BuildContext context) {
    return MarkdownPreview(textToRender: widget.textToRender);
    // final id = Random().nextInt(25);

    // return Image.network(
    //   "https://api.mganczarczyk.pl/tairiku/random/streetmoe?safety=true&seed=$id",
    //   loadingBuilder: (context, child, loadingProgress) {
    //     if (loadingProgress == null) return child;

    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    //   fit: BoxFit.cover,
    // );
  }
}

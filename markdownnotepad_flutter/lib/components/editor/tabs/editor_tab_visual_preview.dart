import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/editor/editor_desktop_header.dart';
import 'package:markdownnotepad/markdown_visual_builder/markdown_preview.dart';

class EditorTabVisualPreview extends StatefulWidget {
  final String textToRender;
  final bool isLiveShareEnabled;
  final VoidCallback toggleLiveShare;

  const EditorTabVisualPreview({
    super.key,
    required this.textToRender,
    required this.isLiveShareEnabled,
    required this.toggleLiveShare,
  });

  @override
  State<EditorTabVisualPreview> createState() => _EditorTabVisualPreviewState();
}

class _EditorTabVisualPreviewState extends State<EditorTabVisualPreview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        EditorDesktopHeader(
          isTitleEditable: false,
          isLiveShareEnabled: widget.isLiveShareEnabled,
          toggleLiveShare: widget.toggleLiveShare,
        ),
        Expanded(
          child: MarkdownPreview(
            textToRender: widget.textToRender,
          ),
        ),
      ],
    );
  }
}

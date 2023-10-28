import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdownnotepad/markdown_visual_builder/mdn_extension_builder.dart';
import 'package:markdownnotepad/markdown_visual_builder/mdn_extension_syntax.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownPreview extends StatelessWidget {
  final String textToRender;

  const MarkdownPreview({
    super.key,
    required this.textToRender,
  });

  @override
  Widget build(BuildContext context) {
    return Markdown(
      selectable: true,
      data: textToRender,
      onTapLink: (text, href, title) async {
        if (href == null) return;

        if (!await launchUrl(Uri.parse(href))) {
          throw Exception('Could not launch $text:$href');
        }
      },
      builders: <String, MarkdownElementBuilder>{
        'mdn_extension': MDNExtensionBuilder(
          context: context,
        ),
      },
      extensionSet: md.ExtensionSet(
        <md.BlockSyntax>[
          ...md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        ],
        <md.InlineSyntax>[
          md.EmojiSyntax(),
          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
          MDNExtensionSyntax(),
        ],
      ),
    );
  }
}

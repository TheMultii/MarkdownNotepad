import 'package:markdown/markdown.dart';

class MDNExtensionSyntax extends InlineSyntax {
  MDNExtensionSyntax() : super(_pattern);

  static const String _pattern = r'\[mdn\](.*)';

  @override
  bool onMatch(InlineParser parser, Match match) {
    parser.addNode(
      Element.text('mdn_extension', match[1]!),
    );
    return true;
  }
}

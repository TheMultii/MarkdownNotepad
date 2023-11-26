import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_security.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eval/flutter_eval.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdownnotepad/enums/extension_status.dart';
import 'package:markdownnotepad/helpers/snake_case_converter.dart';
import 'package:markdownnotepad/markdown_visual_builder/mdn_extension_builder.dart';
import 'package:markdownnotepad/markdown_visual_builder/mdn_extension_syntax.dart';
import 'package:markdownnotepad/viewmodels/extension.dart';
import 'package:markdownnotepad/viewmodels/imported_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownPreview extends StatefulWidget {
  final String textToRender;

  const MarkdownPreview({
    super.key,
    required this.textToRender,
  });

  @override
  State<MarkdownPreview> createState() => _MarkdownPreviewState();
}

class _MarkdownPreviewState extends State<MarkdownPreview> {
  late ImportedExtensions importedExtensions;
  late Runtime pluginsRuntime;

  @override
  void initState() {
    super.initState();

    final ImportedExtensions emptyImportedExtensions = ImportedExtensions(
      extensions: [],
    );
    importedExtensions =
        Hive.box<ImportedExtensions>('imported_extensions').get(
              'imported_extensions',
              defaultValue: emptyImportedExtensions,
            ) ??
            emptyImportedExtensions;

    final compiler = Compiler();
    compiler.addPlugin(flutterEvalPlugin);

    Map<String, Map<String, String>> pluginPackages = {};

    for (MDNExtension extension in importedExtensions.extensions
        .where((extension) => extension.status == ExtensionStatus.active)) {
      pluginPackages[
          'mdn_extension_${SnakeCaseConverter.convert(extension.title)}'] = {
        'main.dart': extension.content,
      };
    }

    final program = compiler.compile(pluginPackages);
    pluginsRuntime = Runtime.ofProgram(program);
    pluginsRuntime.grant(NetworkPermission.any);
    if (pluginPackages.isEmpty) return;
    pluginsRuntime.addPlugin(flutterEvalPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Markdown(
      selectable: true,
      data: widget.textToRender,
      onTapLink: (text, href, title) async {
        if (href == null) return;

        if (!await launchUrl(Uri.parse(href))) {
          throw Exception('Could not launch $text:$href');
        }
      },
      builders: <String, MarkdownElementBuilder>{
        'mdn_extension': MDNExtensionBuilder(
          context: context,
          importedExtensions: importedExtensions,
          pluginsRuntime: pluginsRuntime,
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

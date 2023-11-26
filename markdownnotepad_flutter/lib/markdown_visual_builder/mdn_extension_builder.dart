import 'dart:math';

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:color_parser/color_parser.dart';
import 'package:markdownnotepad/enums/extension_status.dart';
import 'package:markdownnotepad/helpers/snake_case_converter.dart';
import 'package:markdownnotepad/viewmodels/extension.dart';
import 'package:markdownnotepad/viewmodels/imported_extensions.dart';

class MDNExtensionBuilder extends MarkdownElementBuilder {
  final BuildContext context;
  final ImportedExtensions importedExtensions;
  final Runtime pluginsRuntime;

  MDNExtensionBuilder({
    required this.context,
    required this.importedExtensions,
    required this.pluginsRuntime,
  });

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final String textContent = element.textContent;

    String parsedText = textContent.replaceFirst('[mdn]', '');
    String command = parsedText.split(']')[0].replaceFirst('[', '');

    if (command.isNotEmpty) {
      parsedText = parsedText.split(']')[1];
    }

    if (command == 'latex') {
      parsedText = parsedText.replaceFirst('[latex]', '');
      return Math.tex(
        parsedText,
        mathStyle: MathStyle.display,
        onErrorFallback: (errmsg) {
          debugPrint(errmsg.messageWithType);

          return Text(parsedText);
        },
      );
    }

    if (command == 'tairiku' && parsedText.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          "https://api.mganczarczyk.pl/tairiku/random/$parsedText?safety=true&seed=${Random().nextInt(999999)}",
          fit: BoxFit.cover,
        ),
      );
    }

    if (RegExp(r'color=#([0-9A-Fa-f]{6})').firstMatch(command) != null) {
      try {
        final ColorParser color = ColorParser.hex(command.split('=')[1]);

        return Text(
          parsedText,
          style: TextStyle(
            color: color.getColor(),
          ),
        );
      } catch (e) {
        debugPrint(e.toString());

        return Text(parsedText);
      }
    }

    for (MDNExtension extension in importedExtensions.extensions) {
      if (extension.activator == command &&
          extension.status == ExtensionStatus.active) {
        return (pluginsRuntime.executeLib(
          'package:mdn_extension_${SnakeCaseConverter.convert(extension.title)}/main.dart',
          'MDNExtension.',
          [$String(parsedText)],
        ) as $Value)
            .$value;
      }
    }

    return SelectableText(parsedText);
  }
}

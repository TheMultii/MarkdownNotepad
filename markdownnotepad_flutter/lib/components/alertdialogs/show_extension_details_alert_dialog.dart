import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/enums/extension_status.dart';
import 'package:markdownnotepad/helpers/extensions_helper.dart';
import 'package:markdownnotepad/viewmodels/extension.dart';

class ShowExtensionDetailsAlertDialog extends StatelessWidget {
  final MDNExtension extension;

  const ShowExtensionDetailsAlertDialog({
    super.key,
    required this.extension,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      title: Text(extension.title),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Autor:'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              extension.author,
              style: TextStyle(
                color: Theme.of(context)
                    .extension<MarkdownNotepadTheme>()
                    ?.text
                    ?.withOpacity(.6),
              ),
            ),
          ),
          const Text("Wersja:"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              extension.version,
              style: TextStyle(
                color: Theme.of(context)
                    .extension<MarkdownNotepadTheme>()
                    ?.text
                    ?.withOpacity(.6),
              ),
            ),
          ),
          const Text('Aktywator:'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              "[${extension.activator}]",
              style: TextStyle(
                color: Theme.of(context)
                    .extension<MarkdownNotepadTheme>()
                    ?.text
                    ?.withOpacity(.6),
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (extension.status == ExtensionStatus.active)
          TextButton(
            onPressed: () {
              ExtensionsHelper.disableExtension(extension);
              Navigator.of(context).pop();
            },
            child: const Text("Wyłącz"),
          )
        else if (extension.status == ExtensionStatus.inactive)
          TextButton(
            onPressed: () {
              ExtensionsHelper.enableExtension(extension);
              Navigator.of(context).pop();
            },
            child: const Text("Włącz"),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Powrót"),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';

class EditorPage extends StatefulWidget {
  final String id;

  const EditorPage({
    super.key,
    required this.id,
  });

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late MDNDiscordRPC mdnDiscordRPC;
  final controller = CodeController(
    text: '# test',
    language: markdown,
  );
  final fNode = FocusNode();

  @override
  void initState() {
    super.initState();

    controller.text += '\n\n## ${widget.id}';

    mdnDiscordRPC = MDNDiscordRPC();
    mdnDiscordRPC.setPresence(state: "Editing a test #${widget.id} file");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          fNode.requestFocus();
        },
        child: SingleChildScrollView(
          child: CodeTheme(
            data: CodeThemeData(
              styles: {
                ...a11yDarkTheme,
                'root': TextStyle(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  color: const Color(0xfff8f8f2),
                ),
                'title': TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                'section': TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              },
            ),
            child: CodeField(
              controller: controller,
              focusNode: fNode,
            ),
          ),
        ),
      ),
    );
  }
}

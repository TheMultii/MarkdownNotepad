import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:markdownnotepad/components/search_bar_item.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class MDNSearchBarWidget extends StatefulWidget {
  final Function() dismissEntry;

  const MDNSearchBarWidget({
    super.key,
    required this.dismissEntry,
  });

  @override
  State<MDNSearchBarWidget> createState() => _MDNSearchBarWidgetState();
}

class _MDNSearchBarWidgetState extends State<MDNSearchBarWidget> {
  double widgetTop = 10.0;
  String textValue = "";

  bool isSearching = false;

  void dismiss() {
    setState(() {
      widgetTop = -1000;
    });
    Timer(100.ms, () {
      widget.dismissEntry();
    });
  }

  void search() {
    setState(() => isSearching = true);
    debugPrint("Search invoked with value: $textValue");
    Future.delayed(500.ms, () {
      setState(() => isSearching = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double margin = MediaQuery.of(context).size.width * .45 / 2;

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (value) {
        if (value.isKeyPressed(LogicalKeyboardKey.escape)) {
          return dismiss();
        }
      },
      child: Stack(
        children: [
          GestureDetector(
            child: SizedBox.expand(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            onTap: () => dismiss(),
          ),
          AnimatedPositioned(
            duration: 150.ms,
            top: widgetTop,
            left: margin,
            right: margin,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 2.5,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .extension<MarkdownNotepadTheme>()
                      ?.cardColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: TextField(
                                  autofocus: true,
                                  focusNode: FocusNode()..requestFocus(),
                                  onEditingComplete: () => search(),
                                  onChanged: (value) {
                                    setState(() => textValue = value);
                                    search();
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Wyszukaj...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (textValue.isNotEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Theme.of(context)
                                .extension<MarkdownNotepadTheme>()
                                ?.text
                                ?.withOpacity(.5),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              top: 6,
                              bottom: 8,
                              left: 10,
                              right: 10,
                            ),
                            child: isSearching
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3.0,
                                    ),
                                  )
                                : Column(
                                    children: [1, 2, 3, 4, 5]
                                        .map(
                                          (e) => SearchBarItem(
                                            e: e,
                                            isLast: e == 5,
                                            text: textValue,
                                            dismiss: dismiss,
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ),
                        ],
                      ),
                  ],
                ),
              )
                  .animate()
                  .slideY(
                    duration: 100.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(
                    duration: 100.ms,
                    curve: Curves.easeOut,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

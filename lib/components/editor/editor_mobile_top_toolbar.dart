import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/editor/editor_mobile_hover_button.dart';
import 'package:markdownnotepad/enums/editor_tabs.dart';

class EditorMobileTopToolbar extends StatefulWidget {
  final EditorTabs currentTab;
  final Function(EditorTabs) onTabChange;

  const EditorMobileTopToolbar({
    super.key,
    required this.currentTab,
    required this.onTabChange,
  });

  @override
  State<EditorMobileTopToolbar> createState() => _EditorMobileTopToolbarState();
}

class _EditorMobileTopToolbarState extends State<EditorMobileTopToolbar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.white.withOpacity(.125),
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          width: 114,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x66050505),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      EditorMobileHoverButton(
                        text: 'MD',
                        tab: EditorTabs.editor,
                        currentTab: widget.currentTab,
                        onSelect: () {
                          widget.onTabChange(EditorTabs.editor);
                        },
                      ),
                      const SizedBox(width: 8),
                      EditorMobileHoverButton(
                        text: 'VS',
                        tab: EditorTabs.visual,
                        currentTab: widget.currentTab,
                        onSelect: () {
                          widget.onTabChange(EditorTabs.visual);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

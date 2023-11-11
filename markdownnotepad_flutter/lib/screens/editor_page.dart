import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:markdownnotepad/components/editor/editor_desktop_change_tab.dart';
import 'package:markdownnotepad/components/editor/editor_desktop_disable_sidebar.dart';
import 'package:markdownnotepad/components/editor/editor_mobile_top_toolbar.dart';
import 'package:markdownnotepad/components/editor/tabs/editor_tab_editor.dart';
import 'package:markdownnotepad/components/editor/tabs/editor_tab_visual_preview.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/enums/editor_tabs.dart';

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

  EditorTabs selectedTab = EditorTabs.editor;
  bool isEditorSidebarEnabled = true;
  bool isLiveShareEnabled = false;

  @override
  void initState() {
    super.initState();

    controller.text += '\n\n## ${widget.id}';

    mdnDiscordRPC = MDNDiscordRPC();
    mdnDiscordRPC.setPresence(
        state: "Editing a test #${widget.id} file", forceUpdate: false);
  }

  @override
  void dispose() {
    controller.dispose();
    fNode.dispose();
    super.dispose();
  }

  void onTabChange(EditorTabs tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  void toggleEditorSidebar() {
    setState(() {
      isEditorSidebarEnabled = !isEditorSidebarEnabled;
    });
  }

  void toggleLiveShare() {
    setState(() {
      isLiveShareEnabled = !isLiveShareEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double sidebarWidth = 85;
    final Color? sidebarColor = Theme.of(context)
        .extension<MarkdownNotepadTheme>()
        ?.cardColor
        ?.withOpacity(.25);

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: selectedTab == EditorTabs.editor
                    ? EditorTabEditor(
                        controller: controller,
                        focusNode: fNode,
                        sidebarWidth: sidebarWidth,
                        sidebarColor: sidebarColor,
                        editorStyle: a11yDarkTheme,
                        isEditorSidebarEnabled: !Responsive.isMobile(context) &&
                            isEditorSidebarEnabled,
                        isLiveShareEnabled: isLiveShareEnabled,
                        toggleLiveShare: toggleLiveShare,
                      )
                    : EditorTabVisualPreview(
                        textToRender: controller.fullText,
                        isLiveShareEnabled: isLiveShareEnabled,
                        toggleLiveShare: toggleLiveShare,
                      ),
              ),
            ),
            if (!Responsive.isMobile(context))
              Container(
                width: 110,
                height: double.infinity,
                color: sidebarColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    EditorDesktopChangeTab(
                      icon: FeatherIcons.penTool,
                      text: 'Tryb MD',
                      tab: EditorTabs.editor,
                      currentTab: selectedTab,
                      onTabChange: onTabChange,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    EditorDesktopChangeTab(
                      icon: FeatherIcons.eye,
                      text: 'Tryb Visual',
                      tab: EditorTabs.visual,
                      currentTab: selectedTab,
                      onTabChange: onTabChange,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 8.0,
                            bottom: 4.0,
                          ),
                          child: Opacity(
                            opacity: .5,
                            child: Divider(),
                          ),
                        ),
                        EditorDesktopDisableSidebar(
                          isEditorOpen: selectedTab == EditorTabs.editor,
                          text:
                              "W${isEditorSidebarEnabled ? 'y' : ''}łącz sidebar",
                          onTap: toggleEditorSidebar,
                        ),
                      ],
                    )
                        .animate(
                          target: selectedTab == EditorTabs.editor ? 1.0 : 0.0,
                        )
                        .fade(duration: 150.ms, begin: 0.0, end: 1.0),
                  ],
                ),
              ),
          ],
        ),
        if (Responsive.isMobile(context))
          EditorMobileTopToolbar(
            currentTab: selectedTab,
            onTabChange: onTabChange,
          ),
      ],
    );
  }
}

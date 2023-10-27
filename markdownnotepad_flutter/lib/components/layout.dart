import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/drawer/drawer.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/intents/search_intent.dart';

class MDNLayout extends StatefulWidget {
  final Widget child;
  final bool displayDrawer;

  const MDNLayout({
    super.key,
    required this.child,
    required this.displayDrawer,
  });

  @override
  State<MDNLayout> createState() => _MDNLayoutState();
}

class _MDNLayoutState extends State<MDNLayout> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  final NotifyToast notifyToast = NotifyToast();

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context) &&
        drawerKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }

    return Scaffold(
      key: drawerKey,
      drawer: const MDNDrawer(),
      body: SafeArea(
        child: Row(
          children: [
            Responsive.isDesktop(context) && widget.displayDrawer
                ? const Expanded(
                    flex: 2,
                    child: MDNDrawer(),
                  )
                : Container(),
            Expanded(
              flex: 7,
              child: MDNSearchIntent(
                invokeFunction: (Intent intent) {
                  debugPrint("SearchIntent invoked at ${DateTime.now()}");

                  return notifyToast.show(
                    context: context,
                    child: const SampleNotifyToast(),
                  );
                },
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SampleNotifyToast extends StatelessWidget {
  const SampleNotifyToast({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 75,
      padding: const EdgeInsets.only(
        left: 10,
        top: 10,
        bottom: 10,
      ),
      margin: const EdgeInsets.only(
        top: 8.0,
        right: 8.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<MarkdownNotepadTheme>()?.cardColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 10,
            ),
            child: ClipOval(
              child: Image.network(
                "https://api.mganczarczyk.pl/tairiku/ai/streetmoe?safety=true",
                width: 37,
                height: 37,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "test",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "owo",
                  style: TextStyle(
                    color: Theme.of(context)
                        .extension<MarkdownNotepadTheme>()
                        ?.text
                        ?.withOpacity(.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

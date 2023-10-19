import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/components/drawer/drawer.dart';
import 'package:markdownnotepad/components/layout.dart';
import 'package:markdownnotepad/core/app_theme.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:markdownnotepad/providers/data_drawer_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await Hive.initFlutter();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DataDrawerProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Markdown Notepad',
      debugShowCheckedModeBanner: false,
      theme: true
          ? themeDataDark(context, 0xFF8F00FF)
          : themeDataLight(context, 0xFF8F00FF),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pl'),
        Locale('en'),
      ],
      locale: const Locale('pl'),
      home: const MyHomePage(title: 'Markdown Notepad'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late MDNDiscordRPC mdnDiscordRPC;

  final controller = CodeController(
    text: '# test',
    language: markdown,
  );
  final fNode = FocusNode();

  @override
  void initState() {
    super.initState();

    mdnDiscordRPC = MDNDiscordRPC();
    // mdnDiscordRPC.clearPresence();
    mdnDiscordRPC.setPresence(state: "Editing a test file");
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    mdnDiscordRPC.setPresence(
      state: "Counter: $_counter",
      endTimeStamp:
          DateTime.now().add(const Duration(minutes: 1)).millisecondsSinceEpoch,
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: drawerKey,
      drawer: const MDNDrawer(),
      body: SafeArea(
        child: MDNLayout(
          child: SizedBox(
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
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
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
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/core/app_theme.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';

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
          ? themeDataDark(context, 0xFF1AB69D)
          : themeDataLight(context, 0xFF1AB69D),
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

  @override
  void initState() {
    super.initState();

    mdnDiscordRPC = MDNDiscordRPC();
    mdnDiscordRPC.clearPresence();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

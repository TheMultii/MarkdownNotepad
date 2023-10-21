import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/components/drawer/drawer.dart';
import 'package:markdownnotepad/components/layout.dart';

class HomePage extends StatefulWidget {
  final bool displayDrawer;

  const HomePage({
    super.key,
    required this.displayDrawer,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    if (Modular.to.path == "/") {
      Modular.to.pushReplacementNamed("/dashboard/");
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: drawerKey,
      drawer: widget.displayDrawer ? const MDNDrawer() : null,
      body: SafeArea(
        child: MDNLayout(
          displayDrawer: widget.displayDrawer,
          child: const RouterOutlet(),
        ),
      ),
    );
  }
}

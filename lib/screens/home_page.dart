import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/components/drawer/drawer.dart';
import 'package:markdownnotepad/components/layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
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
      drawer: const MDNDrawer(),
      body: const SafeArea(
        child: MDNLayout(
          child: RouterOutlet(),
        ),
      ),
    );
  }
}

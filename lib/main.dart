import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/mdn.app.dart';
import 'package:markdownnotepad/providers/data_drawer_provider.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:markdownnotepad/router_modules/app_module.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DataDrawerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DrawerCurrentTabProvider(),
        ),
      ],
      child: ModularApp(
        module: MDNAppModule(),
        child: const MDNApp(),
      ),
    ),
  );
}

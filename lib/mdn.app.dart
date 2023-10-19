import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/core/app_theme.dart';

class MDNApp extends StatelessWidget {
  const MDNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Markdown Notepad',
      debugShowCheckedModeBanner: false,
      theme: themeDataDark(context, 0xFF8F00FF),
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
      routerConfig: Modular.routerConfig,
    );
  }
}

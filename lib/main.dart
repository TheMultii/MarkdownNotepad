import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mdn/config/router.dart';
import 'package:mdn/providers/data_drawer_provider.dart';
import 'package:mdn/providers/fetch_user_data_drawer_provider.dart';
import 'package:provider/provider.dart';

class MDNHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('mdn');

  HttpOverrides.global = MDNHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FetchUserDataDrawerProvider()),
        ChangeNotifierProvider(create: (_) => DataDrawerProvider()),
      ],
      child: const MarkdownNotepadApp(),
    ),
  );
}

class MarkdownNotepadApp extends StatelessWidget {
  const MarkdownNotepadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Markdown Notepad',
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.sourceSansProTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                )),
        colorScheme: const ColorScheme.dark().copyWith(
            background: const Color(0xFF1C1C1C),
            inverseSurface: const Color(0xFF181818),
            primary: const Color(0xEE8F00FF)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

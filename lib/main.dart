import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/main/main_screen.dart';

void main() {
  runApp(const MarkdownNotepadApp());
}

class MarkdownNotepadApp extends StatelessWidget {
  const MarkdownNotepadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const MainScreen(),
    );
  }
}

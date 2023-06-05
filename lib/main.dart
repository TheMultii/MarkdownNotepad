import 'package:flutter/material.dart';

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

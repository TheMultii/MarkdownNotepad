import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

ThemeData themeDataDark(BuildContext context, int primaryColor) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(primaryColor),
      primary: Color(primaryColor),
      background: const Color.fromARGB(255, 21, 21, 21),
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.manropeTextTheme(
      Theme.of(context).textTheme.apply(
            bodyColor: const Color.fromARGB(255, 248, 248, 248),
            displayColor: const Color.fromARGB(255, 248, 248, 248),
          ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: const Color.fromARGB(100, 100, 100, 100),
      selectionHandleColor: Color(primaryColor),
    ),
    useMaterial3: true,
  ).copyWith(
    extensions: <ThemeExtension<dynamic>>[
      const MarkdownNotepadTheme(
        text: Colors.white,
        drawerBackground: Color(0xFF181818),
      ),
    ],
  );
}

ThemeData themeDataLight(BuildContext context, int primaryColor) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(primaryColor),
      primary: Color(primaryColor),
      background: const Color.fromARGB(255, 247, 247, 247),
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.manropeTextTheme(
      Theme.of(context).textTheme.apply(
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: const Color.fromARGB(100, 100, 100, 100),
      selectionHandleColor: Color(primaryColor),
    ),
    useMaterial3: true,
  ).copyWith(
    extensions: <ThemeExtension<dynamic>>[
      const MarkdownNotepadTheme(
        text: Colors.black,
        drawerBackground: Color(0xFFFAFAFA),
      ),
    ],
  );
}

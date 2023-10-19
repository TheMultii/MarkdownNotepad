import 'package:flutter/material.dart';

@immutable
class MarkdownNotepadTheme extends ThemeExtension<MarkdownNotepadTheme> {
  const MarkdownNotepadTheme({
    required this.text,
    required this.drawerBackground,
  });

  final Color? text;
  final Color? drawerBackground;

  @override
  MarkdownNotepadTheme copyWith({
    Color? text,
    Color? drawerBackground,
  }) {
    return MarkdownNotepadTheme(
      text: text ?? this.text,
      drawerBackground: drawerBackground,
    );
  }

  @override
  MarkdownNotepadTheme lerp(MarkdownNotepadTheme? other, double t) {
    if (other is! MarkdownNotepadTheme) {
      return this;
    }
    return MarkdownNotepadTheme(
      text: Color.lerp(text, other.text, t),
      drawerBackground: Color.lerp(drawerBackground, other.drawerBackground, t),
    );
  }
}

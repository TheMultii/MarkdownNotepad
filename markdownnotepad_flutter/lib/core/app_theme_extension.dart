import 'package:flutter/material.dart';

@immutable
class MarkdownNotepadTheme extends ThemeExtension<MarkdownNotepadTheme> {
  const MarkdownNotepadTheme({
    required this.text,
    required this.drawerBackground,
    required this.cardColor,
  });

  final Color? text;
  final Color? drawerBackground;
  final Color? cardColor;

  @override
  MarkdownNotepadTheme copyWith({
    Color? text,
    Color? drawerBackground,
    Color? cardColor,
  }) {
    return MarkdownNotepadTheme(
      text: text ?? this.text,
      drawerBackground: drawerBackground ?? this.drawerBackground,
      cardColor: cardColor ?? this.cardColor,
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
      cardColor: Color.lerp(cardColor, other.cardColor, t),
    );
  }
}

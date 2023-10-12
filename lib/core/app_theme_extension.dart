import 'package:flutter/material.dart';

@immutable
class MarkdownNotepadTheme extends ThemeExtension<MarkdownNotepadTheme> {
  const MarkdownNotepadTheme({
    required this.text,
  });

  final Color? text;

  @override
  MarkdownNotepadTheme copyWith({
    Color? text,
  }) {
    return MarkdownNotepadTheme(
      text: text ?? this.text,
    );
  }

  @override
  MarkdownNotepadTheme lerp(MarkdownNotepadTheme? other, double t) {
    if (other is! MarkdownNotepadTheme) {
      return this;
    }
    return MarkdownNotepadTheme(
      text: Color.lerp(text, other.text, t),
    );
  }
}

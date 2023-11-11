import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class MDNInputWidget extends StatelessWidget {
  final TextEditingController inputController;
  final String labelText;
  final bool obscureText;
  final String? Function(String?)? validator;

  const MDNInputWidget({
    super.key,
    required this.inputController,
    required this.labelText,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText,
      controller: inputController,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.getFont(
          'Poppins',
          color: Theme.of(context)
              .extension<MarkdownNotepadTheme>()!
              .text!
              .withOpacity(.6),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context)
                .extension<MarkdownNotepadTheme>()!
                .text!
                .withOpacity(.5),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context)
                .extension<MarkdownNotepadTheme>()!
                .text!
                .withOpacity(.9),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: GoogleFonts.getFont(
        'Poppins',
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

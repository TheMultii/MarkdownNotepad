import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class MDNInputWidget extends StatelessWidget {
  final TextEditingController inputController;
  final String labelText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidationMode;
  final Function()? onEditingComplete;

  const MDNInputWidget({
    super.key,
    required this.inputController,
    required this.labelText,
    this.obscureText = false,
    this.validator,
    this.autovalidationMode,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode:
          autovalidationMode ?? AutovalidateMode.onUserInteraction,
      validator: validator,
      obscureText: obscureText,
      controller: inputController,
      cursorColor: Colors.white,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        onEditingComplete?.call();
      },
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
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
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

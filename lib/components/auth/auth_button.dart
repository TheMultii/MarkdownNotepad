import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthButton extends StatelessWidget {
  final String actionText;
  final Function onPressed;

  const AuthButton({
    super.key,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(const Size(300, 50)),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.primary,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          Colors.white,
        ),
        overlayColor: MaterialStateProperty.all<Color>(
          Colors.white.withOpacity(.075),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: Text(
        actionText,
        style: GoogleFonts.getFont(
          'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () => onPressed(),
      // TODO:
      onLongPress: () {
        Modular.to.navigate("/dashboard");
      },
    );
  }
}

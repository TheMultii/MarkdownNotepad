import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:provider/provider.dart';

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
      // TODO: Do not remove this until after the authorization is implemented.
      onLongPress: () {
        const String destination = "/dashboard/";
        context.read<DrawerCurrentTabProvider>().setCurrentTab(destination);
        Modular.to.navigate(destination);
      },
    );
  }
}

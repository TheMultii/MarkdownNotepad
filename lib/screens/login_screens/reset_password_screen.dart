import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdn/components/login/input_widget.dart';
import 'package:mdn/components/mdn_cached_network_image.dart';
import 'package:mdn/config/router.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController mailController = TextEditingController();
  //TODO: add form validation

  @override
  Widget build(BuildContext context) {
    final randomImage =
        ["1123720313524033980", "1123719621581527065"][Random().nextInt(2)];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: MDNCachedNetworkImage(
                  imageURL:
                      "https://api.mganczarczyk.pl/tairiku/display/$randomImage"),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '🤔 Nie pamiętasz hasła?',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, -8.0, 0.0),
                      child: Text(
                        'Zresetuj je',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Colors.white.withOpacity(.6),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    //reset password form
                    Padding(
                      padding: const EdgeInsets.all(100.0),
                      child: Column(
                        children: <Widget>[
                          MDNInputWidget(
                            inputController: mailController,
                            labelText: 'Adres e-mail',
                          ),
                        ],
                      ),
                    ),
                    //Buttons
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(300, 50)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                          Colors.white.withOpacity(.075),
                        ),
                      ),
                      child: Text(
                        'Zresetuj hasło',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        print('Zresetuj hasło');
                        print(mailController.text);
                      },
                      onLongPress: () {
                        router.replace("/");
                      },
                    ),
                    // zaloguj się
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0, bottom: 5.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: <Widget>[
                          const Text('Jeśli pamiętasz hasło, '),
                          RichText(
                            text: TextSpan(
                              text: 'Zaloguj się',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  router.replace('/login');
                                },
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

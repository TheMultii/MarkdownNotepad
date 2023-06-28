import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdn/config/router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final randomImage = [
      "FrFRTDwaMAAF-aq",
      "Fo1tbQ4aUAAn_Fy",
      "FomXyNIaYAA_GZD"
    ][Random().nextInt(3)];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Image.network(
                "https://pbs.twimg.com/media/$randomImage?format=jpg",
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(top: 66),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '👋 Miło Cię poznać',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, -8.0, 0.0),
                      child: Text(
                        'Zarejestruj się',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    //login form
                    //Buttons
                    Padding(
                      padding: const EdgeInsets.only(top: 91),
                      child: ElevatedButton(
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
                          'Zarejestruj się',
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          print('Zarejestruj się');
                        },
                        onLongPress: () {
                          router.replace("/");
                        },
                      ),
                    ),
                    // zaloguj się
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: [
                          const Text('Masz już konto?'),
                          RichText(
                            text: TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  router.replace('/login');
                                },
                              text: 'Zaloguj się',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
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

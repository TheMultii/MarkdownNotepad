import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdn/components/mdn_cached_network_image.dart';
import 'package:mdn/config/router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final randomImage =
        ["1123720313524033980", "1123719621581527065"][Random().nextInt(2)];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: MDNCachedNetworkImage(
                  imageURL:
                      "https://api.mganczarczyk.pl/tairiku/display/$randomImage"),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(top: 66),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '👋 Miło Cię znowu widzieć',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, -8.0, 0.0),
                      child: Text(
                        'Zaloguj się',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Colors.white.withOpacity(.6),
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
                          'Zaloguj się',
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          print('Zaloguj się');
                        },
                        onLongPress: () {
                          router.replace("/");
                        },
                      ),
                    ),
                    // zapomniałeś hasło?
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0, bottom: 5.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: [
                          const Text('Zapomniałeś hasło?'),
                          RichText(
                            text: TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('Zresetuj hasło');
                                },
                              text: 'Zresetuj je',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // zarejestruj się
                    Wrap(
                      spacing: 8.0,
                      children: [
                        const Text(
                          'Nie masz konta?',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                router.replace('/register');
                              },
                            text: 'Zarejestruj się',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
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

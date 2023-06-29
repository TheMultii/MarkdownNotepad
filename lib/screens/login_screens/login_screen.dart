import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdn/components/login/input_widget.dart';
import 'package:mdn/components/mdn_cached_network_image.dart';
import 'package:mdn/config/router.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                    Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Column(
                        children: <Widget>[
                          MDNInputWidget(
                            inputController: mailController,
                            labelText: 'Adres e-mail',
                          ),
                          const SizedBox(
                            width: double.infinity,
                            height: 22,
                          ),
                          MDNInputWidget(
                            inputController: passwordController,
                            labelText: 'Hasło',
                            obscureText: true,
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Text(
                        'Zaloguj się',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        print('Zaloguj się');
                        print(
                            "${mailController.text}|${passwordController.text}");
                      },
                      onLongPress: () {
                        router.replace("/");
                      },
                    ),
                    // zapomniałeś hasło?
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0, bottom: 5.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: <Widget>[
                          const Text('Zapomniałeś hasło?'),
                          RichText(
                            text: TextSpan(
                              text: 'Zresetuj je',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  router.replace('/reset-password');
                                },
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
                      children: <Widget>[
                        const Text(
                          'Nie masz konta?',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Zarejestruj się',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                router.replace('/register');
                              },
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

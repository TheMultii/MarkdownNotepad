import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdn/components/login/input_widget.dart';
import 'package:mdn/components/mdn_cached_network_image.dart';
import 'package:mdn/config/router.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
              child: MDNCachedNetworkImage(
                  imageURL:
                      "https://pbs.twimg.com/media/$randomImage?format=jpg"),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
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
                          color: Colors.white.withOpacity(.6),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    //register form
                    Padding(
                      padding: const EdgeInsets.all(45.0),
                      child: Column(
                        children: <Widget>[
                          MDNInputWidget(
                            inputController: usernameController,
                            labelText: 'Nazwa użytkownika',
                          ),
                          const SizedBox(
                            width: double.infinity,
                            height: 22,
                          ),
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
                          const SizedBox(
                            width: double.infinity,
                            height: 22,
                          ),
                          MDNInputWidget(
                            inputController: confirmPasswordController,
                            labelText: 'Powtórz hasło',
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
                        print(
                            "${usernameController.text}|${mailController.text}|${passwordController.text}|${confirmPasswordController.text}");
                      },
                      onLongPress: () {
                        router.replace("/");
                      },
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

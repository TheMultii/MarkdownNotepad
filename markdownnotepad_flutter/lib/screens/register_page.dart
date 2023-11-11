import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/components/auth/auth_button.dart';
import 'package:markdownnotepad/components/cached_network_image.dart';
import 'package:markdownnotepad/components/input_input.dart';
import 'package:markdownnotepad/helpers/validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
          children: <Widget>[
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
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            MDNInputWidget(
                              inputController: usernameController,
                              labelText: 'Nazwa użytkownika',
                              validator: (usernameValidator) =>
                                  MDNValidator.validateUsername(
                                usernameValidator,
                              ),
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: 22,
                            ),
                            MDNInputWidget(
                              inputController: mailController,
                              labelText: 'Adres e-mail',
                              validator: (emailValidator) =>
                                  MDNValidator.validateEmail(
                                emailValidator,
                              ),
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: 22,
                            ),
                            MDNInputWidget(
                              inputController: passwordController,
                              labelText: 'Hasło',
                              obscureText: true,
                              validator: (passwordValidator) =>
                                  MDNValidator.validatePassword(
                                passwordValidator,
                              ),
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: 22,
                            ),
                            MDNInputWidget(
                              inputController: confirmPasswordController,
                              labelText: 'Powtórz hasło',
                              obscureText: true,
                              validator: (repeatPasswordValidator) =>
                                  MDNValidator.validateRepeatPassword(
                                passwordController.text,
                                repeatPasswordValidator,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Buttons
                    AuthButton(
                      actionText: "Zarejestruj się",
                      onPressed: () {
                        debugPrint(
                            "(register) user: ${usernameController.text} mail: ${mailController.text} password: ${passwordController.text} confirmPassword: ${confirmPasswordController.text}");
                      },
                    ),
                    // zaloguj się
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: <Widget>[
                          const Text('Masz już konto?'),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Modular.to.navigate("/auth/login");
                              },
                              child: Text(
                                'Zaloguj się',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
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

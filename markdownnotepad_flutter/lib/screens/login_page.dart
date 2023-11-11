import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/components/auth/auth_button.dart';
import 'package:markdownnotepad/components/cached_network_image.dart';
import 'package:markdownnotepad/components/input_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String randomImage = [
      "https://images.unsplash.com/photo-1695982206826-970fd4e8e27e?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://api.mganczarczyk.pl/tairiku/display/1123719621581527065"
    ][Random().nextInt(2)];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: MDNCachedNetworkImage(
                imageURL: randomImage,
              ),
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
                    AuthButton(
                      actionText: 'Zaloguj się',
                      onPressed: () {
                        debugPrint(
                            "(login) Login: ${mailController.text} Password: ${passwordController.text}");
                      },
                    ),
                    // zapomniałeś hasło?
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0, bottom: 5.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: <Widget>[
                          const Text('Zapomniałeś hasło?'),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Modular.to.navigate("/auth/reset-password");
                              },
                              child: Text(
                                'Zresetuj je',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
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
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Modular.to.navigate("/auth/register");
                            },
                            child: Text(
                              'Zarejestruj się',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.primary,
                              ),
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/components/auth/auth_button.dart';
import 'package:markdownnotepad/components/cached_network_image.dart';
import 'package:markdownnotepad/components/input_input.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController mailController = TextEditingController();
  late MDNApiService apiService;

  @override
  void initState() {
    super.initState();

    MDNDiscordRPC().clearPresence();
    apiService = context.read<ApiServiceProvider>().apiService;
  }

  @override
  Widget build(BuildContext context) {
    final randomImage = [
      "https://i.redd.it/n9wuwc3dxjvb1.png",
      "https://i.redd.it/gpwwcd0xehub1.jpg"
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
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            MDNInputWidget(
                              inputController: mailController,
                              labelText: 'Adres e-mail',
                              validator: (emailValidator) =>
                                  MDNValidator.validateEmail(
                                emailValidator,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Buttons
                    AuthButton(
                      actionText: "Zresetuj hasło",
                      onPressed: () {
                        debugPrint(
                            "(reset password) mail: ${mailController.text}");
                      },
                    ),
                    // zaloguj się
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0, bottom: 5.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: <Widget>[
                          const Text('Jeśli pamiętasz hasło, '),
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

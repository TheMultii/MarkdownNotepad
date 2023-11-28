// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/components/auth/auth_button.dart';
import 'package:markdownnotepad/components/cached_network_image.dart';
import 'package:markdownnotepad/components/input_input.dart';
import 'package:markdownnotepad/components/notifications/error_notify_toast.dart';
import 'package:markdownnotepad/components/notifications/success_notify_toast.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/helpers/get_logged_in_user_details.dart';
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/models/api_models/login_body_model.dart';
import 'package:markdownnotepad/models/api_responses/message_failure_model.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loggedInUserBox = Hive.box<LoggedInUser>('logged_in_user');
  final NotifyToast notifyToast = NotifyToast();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late MDNApiService apiService;

  @override
  void initState() {
    super.initState();

    MDNDiscordRPC().clearPresence();
    apiService = context.read<ApiServiceProvider>().apiService;
  }

  Future<void> login() async {
    if (MDNValidator.validateUsername(usernameController.text) != null ||
        MDNValidator.validatePassword(passwordController.text) != null) {
      return;
    }

    try {
      final loginData = await apiService.login(
        LoginBodyModel(
          username: usernameController.text,
          password: passwordController.text,
        ),
      );

      final loggedInUser = await getLoggedInUserDetails(
        apiService,
        "Bearer ${loginData!.accessToken}",
      );

      loggedInUserBox.clear();
      loggedInUserBox.put("logged_in_user", loggedInUser);

      notifyToast.show(
        context: context,
        child: const SuccessNotifyToast(
          title: "Pomyślnie zalogowano",
          body: "Za chwilę zostaniesz przekierowany",
          minWidth: 200,
        ),
      );

      await Future.delayed(const Duration(seconds: 1), () {
        context
            .read<CurrentLoggedInUserProvider>()
            .setCurrentUser(loggedInUser);
        context.read<DrawerCurrentTabProvider>().setCurrentTab("/dashboard/");
        Modular.to.navigate("/dashboard/");
      });
    } on DioException catch (e) {
      try {
        final errMsg = MessageFailureModel.fromJson(
          e.response?.data ?? {"message": "Błąd"},
        );
        notifyToast.show(
          context: context,
          child: ErrorNotifyToast(
            title: "Błąd",
            body: errMsg.message,
            minWidth: 200,
          ),
        );
      } catch (e) {
        debugPrint(e.toString());
        notifyToast.show(
          context: context,
          child: const ErrorNotifyToast(
            title: "Błąd",
            body: "Błędne dane",
            minWidth: 200,
          ),
        );
        debugPrint(e.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final String randomImage = [
      "https://pbs.twimg.com/media/Fo1tbQ4aUAAn_Fy?format=jpg",
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
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            MDNInputWidget(
                              inputController: usernameController,
                              labelText: 'Nazwa użytkownika',
                              onEditingComplete: () => login(),
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
                              inputController: passwordController,
                              labelText: 'Hasło',
                              obscureText: true,
                              onEditingComplete: () => login(),
                              validator: (passwordValidator) =>
                                  MDNValidator.validatePassword(
                                passwordValidator,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Buttons
                    AuthButton(
                      actionText: 'Zaloguj się',
                      onPressed: () => login(),
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

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/components/auth/auth_button.dart';
import 'package:markdownnotepad/components/input_input.dart';
import 'package:markdownnotepad/components/notifications/error_notify_toast.dart';
import 'package:markdownnotepad/components/notifications/success_notify_toast.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/helpers/navigation_helper.dart';
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/models/api_models/register_body_model.dart';
import 'package:markdownnotepad/models/api_responses/message_failure_model.dart';
import 'package:markdownnotepad/models/user.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm_list.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:markdownnotepad/viewmodels/server_settings.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final loggedInUserBox = Hive.box<LoggedInUser>('logged_in_user');
  final NotifyToast notifyToast = NotifyToast();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  late MDNApiService apiService;

  final String randomImage = [
    "img-1.jpeg",
    "img-9.jpeg",
  ][Random().nextInt(2)];

  @override
  void initState() {
    super.initState();

    MDNDiscordRPC().clearPresence();
    apiService = context.read<ApiServiceProvider>().apiService;
  }

  Future<void> register() async {
    if (MDNValidator.validateUsername(usernameController.text) != null ||
        MDNValidator.validateEmail(mailController.text) != null ||
        MDNValidator.validatePassword(passwordController.text) != null ||
        MDNValidator.validateRepeatPassword(
              passwordController.text,
              confirmPasswordController.text,
            ) !=
            null) {
      return;
    }

    try {
      final registerData = await apiService.register(
        RegisterBodyModel(
          username: usernameController.text,
          email: mailController.text,
          password: passwordController.text,
        ),
      );

      final userMe = await apiService.getMe(
        "Bearer ${registerData?.accessToken}",
      );

      final loggedInUser = LoggedInUser(
        user: User(
          id: userMe?.id ?? "",
          username: userMe?.username ?? "",
          email: userMe?.email ?? "",
          bio: userMe?.bio ?? "",
          name: userMe?.name ?? "",
          surname: userMe?.surname ?? "",
          createdAt: userMe?.createdAt ?? DateTime.now(),
          updatedAt: userMe?.updatedAt ?? DateTime.now(),
        ),
        accessToken: registerData?.accessToken ?? "",
        timeOfLogin: DateTime.now(),
        tokenExpiration: DateTime.now().add(
          const Duration(
            days: 7,
          ),
        ),
      );

      loggedInUserBox.clear();
      loggedInUserBox.put("logged_in_user", loggedInUser);

      if (!context.mounted) return;
      notifyToast.show(
        context: context,
        child: const SuccessNotifyToast(
          title: "Pomyślnie zalogowano",
          body: "Za chwilę zostaniesz przekierowany",
        ),
      );

      await Future.delayed(const Duration(seconds: 1), () {
        context
            .read<CurrentLoggedInUserProvider>()
            .setCurrentUser(loggedInUser);

        NavigationHelper.navigateToPage(
          context,
          "/dashboard/",
        );
      });
    } on DioException catch (e) {
      try {
        final errMsg = MessageFailureModel.fromJson(
          e.response?.data ?? {"message": "Błąd"},
        );
        if (!context.mounted) return;
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
        if (!context.mounted) return;
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
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Row(
          children: <Widget>[
            isMobile
                ? const SizedBox()
                : Expanded(
                    flex: 6,
                    child: Image.asset(
                      "assets/images/$randomImage",
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
            Expanded(
              flex: 8,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowIndicator();
                  return true;
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    decoration: isMobile
                        ? BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/images/$randomImage",
                              ),
                              opacity: .075,
                            ),
                          )
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          isMobile
                              ? Image.asset(
                                  "assets/icon.png",
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                )
                              : const SizedBox(),
                          Text(
                            '👋 Miło Cię poznać',
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontSize: isMobile ? 24 : 35,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign:
                                isMobile ? TextAlign.center : TextAlign.start,
                          ),
                          Container(
                            transform: Matrix4.translationValues(
                              0.0,
                              isMobile ? -2.0 : -8.0,
                              0.0,
                            ),
                            child: Text(
                              'Zarejestruj się',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                color: Colors.white.withOpacity(.6),
                                fontSize: isMobile ? 12 : 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          //register form
                          Padding(
                            padding: isMobile
                                ? const EdgeInsets.symmetric(
                                    vertical: 20,
                                  )
                                : const EdgeInsets.all(45.0),
                            child: Form(
                              child: Column(
                                children: <Widget>[
                                  MDNInputWidget(
                                    inputController: usernameController,
                                    labelText: 'Nazwa użytkownika',
                                    onEditingComplete: () => register(),
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
                                    onEditingComplete: () => register(),
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
                                    onEditingComplete: () => register(),
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
                                    onEditingComplete: () => register(),
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
                            onPressed: () => register(),
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // zmień serwer
                          Wrap(
                            spacing: 8.0,
                            children: <Widget>[
                              const Text(
                                'Chcesz zmienić serwer?',
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    Hive.box<ServerSettings>('server_settings')
                                        .clear();
                                    Hive.box<EventLogVMList>('event_logs')
                                        .clear();
                                    Hive.box<LoggedInUser>('logged_in_user')
                                        .clear();
                                    Modular.to.navigate('/init-setup/');
                                  },
                                  child: Text(
                                    'Kliknij tutaj',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/core/app_theme.dart';
import 'package:markdownnotepad/models/server_settings.dart';
import 'package:markdownnotepad/screens/loading_splash_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class MDNApp extends StatefulWidget {
  const MDNApp({super.key});

  @override
  State<MDNApp> createState() => _MDNAppState();
}

class _MDNAppState extends State<MDNApp> {
  bool isInitialized = false;
  bool redirectToInitialPage = false;

  @override
  void initState() {
    super.initState();

    final serverSettingsBox = Hive.box<ServerSettings>('server_settings');
    final ServerSettings? savedSettings =
        serverSettingsBox.get('server_settings');

    if (savedSettings?.ipAddress == null || savedSettings!.ipAddress.isEmpty) {
      redirectToInitialPage = true;
    }
    // TODO: maybe check if server is available?
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Markdown Notepad',
      debugShowCheckedModeBanner: false,
      theme: themeDataDark(context, 0xFF8F00FF),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pl'),
        Locale('en'),
      ],
      locale: const Locale('pl'),
      routerConfig: Modular.routerConfig,
      builder: (context, child) {
        if (!isInitialized) {
          return AnimatedSplashScreen.withScreenFunction(
            backgroundColor: Theme.of(context).colorScheme.background,
            splash: const LoadingSplashScreen(),
            splashIconSize: double.infinity,
            screenFunction: () async {
              await Future.delayed(
                const Duration(
                  milliseconds: 2000,
                ),
              );

              setState(() {
                isInitialized = true;
              });

              return child!;
            },
          );
        }

        if (redirectToInitialPage) {
          Modular.to.pushReplacementNamed('/init-setup/');
        }
        return child!;
      },
    );
  }
}

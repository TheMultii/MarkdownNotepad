import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/core/app_theme.dart';
import 'package:markdownnotepad/viewmodels/server_settings.dart';
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

    final ServerSettings? savedSettings =
        Hive.box<ServerSettings>('server_settings').get('server_settings');

    if (savedSettings?.ipAddress == null || savedSettings!.ipAddress.isEmpty) {
      redirectToInitialPage = true;
    }

    LicenseRegistry.addLicense(() => Stream<LicenseEntry>.value(
          const LicenseEntryWithLineBreaks(
            <String>['dart_discord_rpc'],
            '''
Changes:

- Added support for the newer version of Flutter and used dependencies''',
          ),
        ));

    LicenseRegistry.addLicense(() => Stream<LicenseEntry>.value(
          const LicenseEntryWithLineBreaks(
            <String>['flutter_code_editor'],
            '''
Changes:

- Added support for live share indicators in the gutter

- Fixed issue with code suggestion popup position

- Disabled code suggestion popup, as it is not necessary for a markdown editor''',
          ),
        ));

    LicenseRegistry.addLicense(() => Stream<LicenseEntry>.value(
          const LicenseEntryWithLineBreaks(
            <String>[' Markdown Notepad'],
            '''
MIT License

Copyright (c) 2023 Marcel Gańczarczyk

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.''',
          ),
        ));
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

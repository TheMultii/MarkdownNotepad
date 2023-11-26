import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/enums/extension_status.dart';
import 'package:markdownnotepad/mdn.app.dart';
import 'package:markdownnotepad/models/catalog.dart';
import 'package:markdownnotepad/models/catalog_simple.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/models/note_simple.dart';
import 'package:markdownnotepad/models/notetag.dart';
import 'package:markdownnotepad/models/user_simple.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/viewmodels/extension.dart';
import 'package:markdownnotepad/viewmodels/imported_extensions.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:markdownnotepad/viewmodels/server_settings.dart';
import 'package:markdownnotepad/models/user.dart';
import 'package:markdownnotepad/providers/data_drawer_provider.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:markdownnotepad/router_modules/app_module.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ServerSettingsAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NoteSimpleAdapter());
  Hive.registerAdapter(NoteTagAdapter());
  Hive.registerAdapter(CatalogAdapter());
  Hive.registerAdapter(CatalogSimpleAdapter());
  Hive.registerAdapter(LoggedInUserAdapter());
  Hive.registerAdapter(ExtensionStatusAdapter());
  Hive.registerAdapter(MDNExtensionAdapter());
  Hive.registerAdapter(ImportedExtensionsAdapter());
  Hive.registerAdapter(UserSimpleAdapter());
  await Hive.openBox<ServerSettings>('server_settings');
  await Hive.openBox<LoggedInUser>('logged_in_user');
  await Hive.openBox<ImportedExtensions>('imported_extensions');

  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await windowManager.ensureInitialized();

    const WindowOptions windowOptions = WindowOptions(
      size: Size(1280, 720),
      center: true,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  setPathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DataDrawerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DrawerCurrentTabProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CurrentLoggedInUserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ApiServiceProvider(),
        ),
      ],
      child: ModularApp(
        module: MDNAppModule(),
        child: const MDNApp(),
      ),
    ),
  );
}

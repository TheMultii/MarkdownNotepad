import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/enums/extension_status.dart';
import 'package:markdownnotepad/mdn.app.dart';
import 'package:markdownnotepad/models/catalog.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/models/notetag.dart';
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

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ServerSettingsAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NoteTagAdapter());
  Hive.registerAdapter(CatalogAdapter());
  Hive.registerAdapter(LoggedInUserAdapter());
  Hive.registerAdapter(ExtensionStatusAdapter());
  Hive.registerAdapter(MDNExtensionAdapter());
  Hive.registerAdapter(ImportedExtensionsAdapter());
  await Hive.openBox<ServerSettings>('server_settings');
  await Hive.openBox<User>('user');

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
      ],
      child: ModularApp(
        module: MDNAppModule(),
        child: const MDNApp(),
      ),
    ),
  );
}

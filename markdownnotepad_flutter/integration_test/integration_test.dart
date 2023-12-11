import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/enums/dashboard_history_item_actions.dart';
import 'package:markdownnotepad/enums/extension_status.dart';
import 'package:markdownnotepad/models/catalog.dart';
import 'package:markdownnotepad/models/catalog_simple.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/models/note_simple.dart';
import 'package:markdownnotepad/models/notetag.dart';
import 'package:markdownnotepad/models/notetag_simple.dart';
import 'package:markdownnotepad/models/user.dart';
import 'package:markdownnotepad/models/user_simple.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/providers/data_drawer_provider.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:markdownnotepad/screens/init_setup_page.dart';
import 'package:markdownnotepad/screens/login_page.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm_list.dart';
import 'package:markdownnotepad/viewmodels/extension.dart';
import 'package:markdownnotepad/viewmodels/imported_extensions.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:markdownnotepad/viewmodels/server_settings.dart';
import 'package:provider/provider.dart';

Future<void> prepare() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ServerSettingsAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NoteSimpleAdapter());
  Hive.registerAdapter(NoteTagAdapter());
  Hive.registerAdapter(NoteTagSimpleAdapter());
  Hive.registerAdapter(CatalogAdapter());
  Hive.registerAdapter(CatalogSimpleAdapter());
  Hive.registerAdapter(LoggedInUserAdapter());
  Hive.registerAdapter(ExtensionStatusAdapter());
  Hive.registerAdapter(MDNExtensionAdapter());
  Hive.registerAdapter(ImportedExtensionsAdapter());
  Hive.registerAdapter(UserSimpleAdapter());
  Hive.registerAdapter(DashboardHistoryItemActionsAdapter());
  Hive.registerAdapter(EventLogVMAdapter());
  Hive.registerAdapter(EventLogVMListAdapter());
  await Hive.openBox<ServerSettings>('server_settings');
  await Hive.openBox<LoggedInUser>('logged_in_user');
  await Hive.openBox<ImportedExtensions>('imported_extensions');
  await Hive.openBox<EventLogVMList>('event_logs');
}

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await prepare();

  group('end-to-end InitSetupPage', () {
    testWidgets('widget contains an image with a logo', (tester) async {
      // Load app widget.
      await tester.pumpWidget(
        const MaterialApp(
          home: InitSetupPage(),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets(
        'widget contains a tappable button with a "Tryb zaawansowany" text',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: InitSetupPage(),
        ),
      );
      expect(find.widgetWithText(ElevatedButton, "Tryb zaawansowany"),
          findsOneWidget);

      await tester
          .tap(find.widgetWithText(ElevatedButton, "Tryb zaawansowany"));
    });

    testWidgets(
        'widget contains a non-tappable button with a "Przejdź dalej" text',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: InitSetupPage(),
        ),
      );
      expect(
          find.widgetWithText(ElevatedButton, "Przejdź dalej"), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, "Przejdź dalej"));

      await tester.pump();
    });

    testWidgets(
        'after clicking "Tryb zaawansowany" button, widget contains two TextFields',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: InitSetupPage(),
        ),
      );
      await tester
          .tap(find.widgetWithText(ElevatedButton, "Tryb zaawansowany"));

      await tester.pump();

      expect(find.byType(TextField), findsNWidgets(2));
    });
  });
  });
}

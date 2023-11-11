import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/router_modules/auth_module.dart';
import 'package:markdownnotepad/router_modules/init_setup_module.dart';
import 'package:markdownnotepad/router_modules/miscellaneous_module.dart';
import 'package:markdownnotepad/router_modules/dashboard_module.dart';
import 'package:markdownnotepad/router_modules/editor_module.dart';
import 'package:markdownnotepad/screens/home_page.dart';

class MDNAppModule extends Module {
  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const HomePage(displayDrawer: true),
      children: [
        ModuleRoute(
          "/dashboard",
          module: DashboardModule(),
          transition: TransitionType.fadeIn,
          duration: const Duration(milliseconds: 150),
        ),
        ModuleRoute(
          "/editor",
          module: EditorModule(),
          transition: TransitionType.fadeIn,
          duration: const Duration(milliseconds: 150),
        ),
        ModuleRoute(
          "/miscellaneous",
          module: MiscellaneousModule(),
          transition: TransitionType.fadeIn,
          duration: const Duration(milliseconds: 150),
        ),
      ],
    );
    r.child(
      '/init-setup',
      child: (context) => const RouterOutlet(),
      children: [
        ModuleRoute(
          '/',
          module: InitSetupModule(),
          transition: TransitionType.fadeIn,
          duration: const Duration(milliseconds: 150),
        ),
      ],
    );
    r.child(
      '/auth',
      child: (context) => const HomePage(displayDrawer: false),
      children: [
        ModuleRoute(
          '/',
          module: AuthModule(),
          transition: TransitionType.fadeIn,
          duration: const Duration(milliseconds: 150),
        ),
      ],
    );
  }
}

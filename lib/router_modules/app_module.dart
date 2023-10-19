import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/router_modules/miscellaneous_module.dart';
import 'package:markdownnotepad/router_modules/dashboard_module.dart';
import 'package:markdownnotepad/router_modules/editor_module.dart';
import 'package:markdownnotepad/screens/home_page.dart';

class MDNAppModule extends Module {
  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const HomePage(),
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
  }
}

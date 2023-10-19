import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/screens/dashboard_page.dart';

class DashboardModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (context) => const DashboardPage());
  }
}

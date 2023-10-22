import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/screens/dashboard_page.dart';
import 'package:markdownnotepad/screens/directory_page.dart';

class DashboardModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (context) => const DashboardPage());
    r.child(
      '/directory/:id',
      child: (context) => DirectoryPage(
        directoryId: r.args.params['id'],
      ),
    );
  }
}

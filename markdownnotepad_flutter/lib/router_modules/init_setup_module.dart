import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/screens/init_setup_page.dart';

class InitSetupModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (context) => const InitSetupPage());
  }
}

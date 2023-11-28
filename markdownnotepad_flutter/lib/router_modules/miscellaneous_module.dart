import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/screens/account_page.dart';
import 'package:markdownnotepad/screens/extensions_page.dart';
import 'package:markdownnotepad/screens/legal_page.dart';

class MiscellaneousModule extends Module {
  @override
  void routes(r) {
    r.child('/account', child: (context) => const AccountPage());
    r.child('/extensions', child: (context) => const ExtensionsPage());
    r.child('/legal', child: (context) => const LegalPage());
  }
}

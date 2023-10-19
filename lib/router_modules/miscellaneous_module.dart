import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/screens/account_page.dart';

class MiscellaneousModule extends Module {
  @override
  void routes(r) {
    r.child('/account', child: (context) => const AccountPage());
    r.child('/extensions', child: (context) => const AccountPage());
    r.child('/login', child: (context) => const AccountPage());
    r.child('/register', child: (context) => const AccountPage());
  }
}

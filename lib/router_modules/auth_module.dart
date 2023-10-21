import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/screens/login_page.dart';
import 'package:markdownnotepad/screens/register_page.dart';
import 'package:markdownnotepad/screens/reset_password_page.dart';

class AuthModule extends Module {
  @override
  void routes(r) {
    r.child('/login', child: (context) => const LoginPage());
    r.child('/register', child: (context) => const RegisterPage());
    r.child('/reset-password', child: (context) => const ResetPasswordPage());
  }
}

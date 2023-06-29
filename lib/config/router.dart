import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mdn/screens/account_screen.dart';
import 'package:mdn/screens/extensions_screen.dart';
import 'package:mdn/screens/main_screen.dart';
import 'package:mdn/screens/settings_screen.dart';
import 'package:mdn/screens/login_screens/login_screen.dart';
import 'package:mdn/screens/login_screens/register_screen.dart';
import 'package:mdn/screens/login_screens/reset_password_screen.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'main-screen',
      builder: (BuildContext context, GoRouterState state) =>
          const MainScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login-screen',
      builder: (BuildContext context, GoRouterState state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register-screen',
      builder: (BuildContext context, GoRouterState state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      name: 'reset-password-screen',
      builder: (BuildContext context, GoRouterState state) =>
          const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings-screen',
      builder: (BuildContext context, GoRouterState state) =>
          const SettingsScreen(),
    ),
    GoRoute(
      path: '/extensions',
      name: 'extensions-screen',
      builder: (BuildContext context, GoRouterState state) =>
          const ExtensionsScreen(),
    ),
    GoRoute(
      path: '/account',
      name: 'account-screen',
      builder: (BuildContext context, GoRouterState state) =>
          const AccountScreen(),
    ),
  ],
);

final List<Map<String, String>> namedRoutes = [
  {
    'name': 'Dashboard',
    'path': '/',
  },
  {
    'name': 'Ustawienia',
    'path': '/settings',
  },
  {
    'name': 'Rozszerzenia',
    'path': '/extensions',
  },
  {
    'name': 'Konto',
    'path': '/account',
  },
  {
    'name': 'Zaloguj się',
    'path': '/login',
  },
  {
    'name': 'Zarejestruj się',
    'path': '/register',
  },
  {
    'name': 'Zresetuj hasło',
    'path': '/reset-password',
  },
];

String getRouteName(String path) {
  return namedRoutes.firstWhere((element) => element['path'] == path)['name'] ??
      path;
}

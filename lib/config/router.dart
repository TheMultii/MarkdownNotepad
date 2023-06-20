import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mdn/screens/main/main_screen.dart';
import 'package:mdn/screens/main/settings_screen.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'main-screen',
      builder: (BuildContext context, GoRouterState state) =>
          const MainScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings-screen',
      builder: (BuildContext context, GoRouterState state) =>
          const SettingsScreen(),
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
];

String getRouteName(String path) {
  return namedRoutes.firstWhere((element) => element['path'] == path)['name'] ??
      path;
}

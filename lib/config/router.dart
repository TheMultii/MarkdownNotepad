import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mdn/screens/main/main_screen.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'main-screen',
      builder: (BuildContext context, GoRouterState state) =>
          const MainScreen(),
    ),
  ],
);

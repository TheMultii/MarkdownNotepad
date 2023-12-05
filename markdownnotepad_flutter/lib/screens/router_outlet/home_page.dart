import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart'
    show Modular, ParallelRoute, RouterOutlet;
import 'package:markdownnotepad/components/drawer/drawer.dart';
import 'package:markdownnotepad/components/layout.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/helpers/navigation_helper.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomePage extends StatefulWidget {
  final bool displayDrawer;

  const HomePage({
    super.key,
    required this.displayDrawer,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    if (Modular.to.path == "/") {
      NavigationHelper.navigateToPage(
        context,
        "/dashboard/",
      );
    }

    BackButtonInterceptor.add(
      backButtonHandler,
      name: "HomePageBackButtonInterceptor",
    );
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backButtonHandler);
    super.dispose();
  }

  bool backButtonHandler(bool stopDefaultButtonEvent, RouteInfo info) {
    const String dashboardRoute = "/dashboard/";
    final String currentRoute = Modular.to.path;
    if (currentRoute == dashboardRoute) {
      return false;
    }

    final navigateHistory = Modular.to.navigateHistory;
    if (navigateHistory.length > 1) {
      final ParallelRoute previousRoute =
          navigateHistory[navigateHistory.length - 2];

      final String destination =
          previousRoute.name == "/" ? dashboardRoute : previousRoute.name;

      NavigationHelper.navigateToPage(
        context,
        destination,
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: drawerKey,
      drawer: widget.displayDrawer ? const MDNDrawer() : null,
      body: SafeArea(
        child: MDNLayout(
          displayDrawer: widget.displayDrawer,
          child: const RouterOutlet(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:provider/provider.dart';

class NavigationHelper {
  static void navigateToPage(
    BuildContext context,
    String destination, {
    Map<String, dynamic>? arguments,
  }) {
    context.read<DrawerCurrentTabProvider>().setCurrentTab(destination);
    Modular.to.navigate(
      destination,
      arguments: arguments,
    );
  }
}

import 'package:flutter/material.dart';

class DrawerCurrentTabProvider extends ChangeNotifier {
  String _currentTab = "/dashboard/";

  String get currentTab => _currentTab;

  void setCurrentTab(String newTab) {
    _currentTab = newTab;
    notifyListeners();
  }
}

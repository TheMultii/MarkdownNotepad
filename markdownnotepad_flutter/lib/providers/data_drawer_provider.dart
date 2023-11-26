import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';

class DataDrawerProvider with ChangeNotifier {
  double _scrollPosition = 0;
  double _drawerWidth = 0.0;

  double get scrollPosition => _scrollPosition;

  double getDrawerWidth(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return isMobile ? 0 : _drawerWidth;
  }

  void setScrollPosition(double newPosition) {
    _scrollPosition = newPosition;

    /*
      There is no need for notifyListeners()
      because the current state of the widget
      is not changed, it is only needed for
      future rendering.
    */
  }

  void setDrawerWidth(double newWidth) {
    _drawerWidth = newWidth;

    /*
      There is no need for notifyListeners()
      because the current state of the widget
      is not changed, it is only needed for
      future rendering.
    */
  }
}

import 'package:flutter/material.dart';

class DataDrawerProvider with ChangeNotifier {
  double _scrollPosition = 0;

  double get scrollPosition => _scrollPosition;

  void setScrollPosition(double newPosition) {
    _scrollPosition = newPosition;

    /*
      There is no need for notifyListeners()
      because the current state of the widget
      is not changed, it is only needed for
      future rendering.
    */
  }
}

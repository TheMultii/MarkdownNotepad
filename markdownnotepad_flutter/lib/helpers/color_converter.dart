import 'package:flutter/material.dart';

class ColorConverter {
  static Color parseFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }

    int intValue = int.parse(hexColor, radix: 16);
    return Color(intValue);
  }

  static String parseToHex(Color color) {
    return "#${color.value.toRadixString(16).substring(2)}";
  }
}

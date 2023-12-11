import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:markdownnotepad/helpers/color_converter.dart';

void main() {
  test('parseFromHex should parse a valid hex color string', () {
    expect(ColorConverter.parseFromHex('#FF0000'), const Color(0xFFFF0000));
    expect(ColorConverter.parseFromHex('#00FF00'), const Color(0xFF00FF00));
    expect(ColorConverter.parseFromHex('#0000FF'), const Color(0xFF0000FF));
    expect(ColorConverter.parseFromHex('#4285F4'), const Color(0xFF4285F4));
    expect(ColorConverter.parseFromHex('#F44336'), const Color(0xFFF44336));
  });

  test('parseToHex should convert a valid color to hex string', () {
    expect(ColorConverter.parseToHex(const Color(0xFFff0000)), '#ff0000');
    expect(ColorConverter.parseToHex(const Color(0xFFFF00FF)), '#ff00ff');
    expect(ColorConverter.parseToHex(const Color(0xFF0000FF)), '#0000ff');
    expect(ColorConverter.parseToHex(const Color(0xFF4285F4)), '#4285f4');
    expect(ColorConverter.parseToHex(const Color(0xFFF44336)), '#f44336');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:markdownnotepad/helpers/add_zero.dart';

void main() {
  group('add zero tests', () {
    test('addZero should add a leading zero to a single-digit number', () {
      expect(addZero(1), '01');
      expect(addZero(2), '02');
    });

    test('addZero should not modify a two-digit number', () {
      expect(addZero(10), '10');
      expect(addZero(20), '20');
    });
  });
}

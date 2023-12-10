import 'package:flutter_test/flutter_test.dart';

void main() {
  test("1 is equal 1", () {
    int number = 1;
    int expected = 1;

    expect(number, expected);
  });
}

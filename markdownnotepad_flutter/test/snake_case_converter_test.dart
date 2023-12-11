import 'package:flutter_test/flutter_test.dart';
import 'package:markdownnotepad/helpers/snake_case_converter.dart';

void main() {
  group('StringExtension tests', () {
    test('capitalize on non-empty string', () {
      expect('hello'.capitalize(), 'Hello');
    });

    test('capitalize on empty string', () {
      expect(''.capitalize(), '');
    });
  });

  group('SnakeCaseConverter tests', () {
    test('convert with spaces and special characters', () {
      expect(SnakeCaseConverter.convert('Hello World!'), 'hello_world');
    });

    test('convert with repeated underscores', () {
      expect(SnakeCaseConverter.convert('  foo   bar  '), '_foo_bar_');
    });

    test('convert with mixed case and numbers', () {
      expect(SnakeCaseConverter.convert('CamelCase123'), 'camelcase123');
    });

    test('convert with empty string', () {
      expect(SnakeCaseConverter.convert(''), '');
    });
  });
}

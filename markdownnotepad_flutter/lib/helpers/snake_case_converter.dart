extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

class SnakeCaseConverter {
  static String convert(String text) {
    String snakeCase = text.replaceAll(' ', '_');

    snakeCase = snakeCase.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
    snakeCase = snakeCase.replaceAll(RegExp(r'_+'), '_');
    return snakeCase.toLowerCase();
  }
}

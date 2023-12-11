import 'package:flutter_test/flutter_test.dart';
import 'package:markdownnotepad/helpers/pluralize_helper.dart';

void main() {
  group('Pluralize tests', () {
    test('pluralizeYears', () {
      expect(Pluralize.pluralizeYears(1), 'rok');
      expect(Pluralize.pluralizeYears(2), 'lata');
      expect(Pluralize.pluralizeYears(4), 'lata');
      expect(Pluralize.pluralizeYears(5), 'lat');
      expect(Pluralize.pluralizeYears(10), 'lat');
    });

    test('pluralizeDays', () {
      expect(Pluralize.pluralizeDays(1), 'dzień');
      expect(Pluralize.pluralizeDays(2), 'dni');
      expect(Pluralize.pluralizeDays(5), 'dni');
      expect(Pluralize.pluralizeDays(10), 'dni');
    });

    test('pluralizeHours', () {
      expect(Pluralize.pluralizeHours(1), 'godzinę');
      expect(Pluralize.pluralizeHours(2), 'godziny');
      expect(Pluralize.pluralizeHours(4), 'godziny');
      expect(Pluralize.pluralizeHours(5), 'godzin');
      expect(Pluralize.pluralizeHours(10), 'godzin');
    });

    test('pluralizeMinutes', () {
      expect(Pluralize.pluralizeMinutes(1), 'minutę');
      expect(Pluralize.pluralizeMinutes(2), 'minuty');
      expect(Pluralize.pluralizeMinutes(4), 'minuty');
      expect(Pluralize.pluralizeMinutes(5), 'minut');
      expect(Pluralize.pluralizeMinutes(10), 'minut');
    });

    test('pluralizeSeconds', () {
      expect(Pluralize.pluralizeSeconds(1), 'sekundę');
      expect(Pluralize.pluralizeSeconds(2), 'sekundy');
      expect(Pluralize.pluralizeSeconds(4), 'sekundy');
      expect(Pluralize.pluralizeSeconds(5), 'sekund');
      expect(Pluralize.pluralizeSeconds(10), 'sekund');
    });

    test('pluralizeExtensions', () {
      expect(Pluralize.pluralizeExtensions(1), 'rozszerzenie');
      expect(Pluralize.pluralizeExtensions(2), 'rozszerzenia');
      expect(Pluralize.pluralizeExtensions(4), 'rozszerzenia');
      expect(Pluralize.pluralizeExtensions(5), 'rozszerzeń');
      expect(Pluralize.pluralizeExtensions(10), 'rozszerzeń');
    });
  });
}

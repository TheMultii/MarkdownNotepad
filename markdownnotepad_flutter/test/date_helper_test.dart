import 'package:flutter_test/flutter_test.dart';
import 'package:markdownnotepad/helpers/date_helper.dart';

void main() {
  group('DateHelper tests', () {
    test('getFormattedDateString', () {
      expect(DateHelper.getFormattedDateString('2023-12-11'), '11.12.2023');
    });

    test('getFormattedTimeString', () {
      expect(DateHelper.getFormattedTimeString('2023-12-11T08:30:00'), '08:30');
    });

    test('getFormattedDateTimeString', () {
      expect(
        DateHelper.getFormattedDateTimeString('2023-12-11T08:30:00'),
        '11.12.2023 08:30',
      );
    });

    test('getFormattedDate', () {
      final dateTime = DateTime(2023, 12, 11);
      expect(DateHelper.getFormattedDate(dateTime), '11.12.2023');
    });

    test('getFormattedTime', () {
      final dateTime = DateTime(2023, 12, 11, 8, 30);
      expect(DateHelper.getFormattedTime(dateTime), '08:30');
    });

    test('getFormattedDateTime', () {
      final dateTime = DateTime(2023, 12, 11, 8, 30);
      expect(
        DateHelper.getFormattedDateTime(dateTime),
        '11.12.2023 08:30',
      );
    });
  });
}

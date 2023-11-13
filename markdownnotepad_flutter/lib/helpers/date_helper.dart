import 'package:markdownnotepad/helpers/add_zero.dart';

class DateHelper {
  static String getFormattedDateString(String dateTime) {
    final dT = DateTime.parse(dateTime);
    return "${dT.day}.${addZero(dT.month)}.${dT.year}";
  }

  static String getFormattedTimeString(String dateTime) {
    final dT = DateTime.parse(dateTime);
    return "${addZero(dT.hour)}:${addZero(dT.minute)}";
  }

  static String getFormattedDateTimeString(String dateTime) {
    final dT = DateTime.parse(dateTime);
    return "${getFormattedDate(dT)} ${getFormattedTime(dT)}";
  }

  static String getFormattedDate(DateTime dateTime) {
    return "${dateTime.day}.${addZero(dateTime.month)}.${dateTime.year}";
  }

  static String getFormattedTime(DateTime dateTime) {
    return "${addZero(dateTime.hour)}:${addZero(dateTime.minute)}";
  }

  static String getFormattedDateTime(DateTime dateTime) {
    return "${getFormattedDate(dateTime)} ${getFormattedTime(dateTime)}";
  }
}

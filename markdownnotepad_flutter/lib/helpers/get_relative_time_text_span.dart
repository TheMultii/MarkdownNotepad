import 'package:flutter/material.dart';
import 'package:markdownnotepad/helpers/date_helper.dart';
import 'package:markdownnotepad/helpers/pluralize_helper.dart';

TextSpan getRelativeTimeTextSpan(DateTime actionDateTime) {
  String relativeTime = "";

  final timeDifference = DateTime.now().difference(actionDateTime);

  if (timeDifference.inDays >= 365) {
    final yearsAgo = timeDifference.inDays ~/ 365;
    relativeTime = "$yearsAgo ${Pluralize.pluralizeYears(yearsAgo)} temu";
  } else if (timeDifference.inDays >= 1) {
    final daysAgo = timeDifference.inDays;
    relativeTime = "$daysAgo ${Pluralize.pluralizeDays(daysAgo)} temu";
  } else if (timeDifference.inHours >= 1) {
    final hoursAgo = timeDifference.inHours;
    relativeTime = "$hoursAgo ${Pluralize.pluralizeHours(hoursAgo)} temu";
  } else if (timeDifference.inMinutes >= 1) {
    final minutesAgo = timeDifference.inMinutes;
    relativeTime = "$minutesAgo ${Pluralize.pluralizeMinutes(minutesAgo)} temu";
  } else {
    relativeTime = "Przed chwilą";
  }

  String dateString = DateHelper.getFormattedDate(actionDateTime);

  return TextSpan(
    text: relativeTime,
    children: [
      const TextSpan(text: " ・ "),
      TextSpan(text: dateString),
    ],
  );
}

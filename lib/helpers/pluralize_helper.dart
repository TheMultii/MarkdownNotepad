class Pluralize {
  static String pluralizeYears(int years) {
    if (years == 1) return "rok";
    if (years < 5) return "lat";
    return "lata";
  }

  static String pluralizeDays(int days) {
    if (days == 1) return "dzień";
    return "dni";
  }

  static String pluralizeHours(int hours) {
    if (hours == 1) return "godzinę";
    if (hours < 5) return "godziny";
    return "godzin";
  }

  static String pluralizeMinutes(int minutes) {
    if (minutes == 1) return "minutę";
    if (minutes < 5) return "minuty";
    return "minut";
  }

  static String pluralizeSeconds(int seconds) {
    if (seconds == 1) return "sekundę";
    if (seconds < 5) return "sekundy";
    return "sekund";
  }
}

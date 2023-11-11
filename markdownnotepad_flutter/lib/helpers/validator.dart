import 'package:flutterfly/flutterfly.dart';

class MDNValidator {
  static String? validateIPAddress(String? ipAddress) {
    if (ipAddress == null || ipAddress.isEmpty) {
      return "Adres IP nie może być pusty";
    }

    final RegExp ipv4RegExp = RegExp(
      r"^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",
      caseSensitive: false,
      multiLine: false,
    );

    final RegExp ipv6RegExp = RegExp(
      r"(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))",
      caseSensitive: false,
      multiLine: false,
    );

    final bool isValid =
        ipv4RegExp.hasMatch(ipAddress) || ipv6RegExp.hasMatch(ipAddress);

    if (!isValid) {
      return "Niepoprawny adres IP";
    }
    return null;
  }

  static String? validatePort(String? port) {
    return ValidatorNumber(port)
        .between(
          80,
          65535,
          errMsg: (min, max) => "Port musi być pomiędzy $min a $max",
        )
        .build();
  }

  static String? validateUsername(String? username) {
    return Validator(username)
        .length(
            min: 4,
            max: 20,
            errMsg: (uname, min, max) =>
                "Nazwa użytkownika musi mieć od $min do $max znaków")
        .build();
  }

  static String? validatePassword(String? password) {
    return Validator(password)
        .length(
            min: 8,
            max: 32,
            errMsg: (pass, min, max) =>
                "Hasło musi mieć od $min do $max znaków")
        .build();
  }
}

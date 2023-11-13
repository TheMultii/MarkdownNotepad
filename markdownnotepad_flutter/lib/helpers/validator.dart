class MDNValidator {
  static String? validateIPAddress(String? ipAddress) {
    return ValidatorString(ipAddress)
        .isNotEmpty(errMsg: "Adres IP nie może być pusty")
        .ipAddress(
          errMsg: "Niepoprawny adres IP",
        )
        .build();
  }

  static String? validatePort(String? port) {
    return ValidatorNumber(port)
        .between(
          80,
          65535,
          errMsg: "Port musi być pomiędzy 80 a 65535",
        )
        .build();
  }

  static String? validateUsername(String? username) {
    return Validator(username)
        .length(
          min: 4,
          max: 20,
          errMsg: "Nazwa użytkownika musi mieć od 4 do 20 znaków",
        )
        .build();
  }

  static String? validatePassword(String? password) {
    return Validator(password)
        .length(
          min: 8,
          max: 32,
          errMsg: "Hasło musi mieć od 8 do 32 znaków",
        )
        .build();
  }

  static String? validateRepeatPassword(
      String? password, String? repeatPassword) {
    if (password != repeatPassword) {
      return "Hasła muszą być takie same";
    }
    return null;
  }

  static String? validateEmail(String? email) {
    return ValidatorString(email)
        .email(
          errMsg: "Niepoprawny adres e-mail",
        )
        .length(
          min: 4,
          max: 320,
          errMsg: "Adres e-mail musi mieć od 4 do 320 znaków",
        )
        .build();
  }

  static String? validateName(String? name) {
    return ValidatorString(name)
        .length(
          min: 0,
          max: 32,
          errMsg: "Imię musi mieć maksymalnie 32 znaki",
        )
        .build();
  }

  static String? validateSurname(String? surname) {
    return ValidatorString(surname)
        .length(
          min: 0,
          max: 32,
          errMsg: "Nazwisko musi mieć maksymalnie 32 znaki",
        )
        .build();
  }
}

class Validator {
  String? value;
  String? errorMessage;

  Validator(this.value);

  Validator length(
      {required int min, required int max, required String errMsg}) {
    if (errorMessage != null) return this;
    if (value != null && (value!.length < min || value!.length > max)) {
      errorMessage = errMsg;
    }
    return this;
  }

  String? build() {
    return errorMessage;
  }
}

class ValidatorNumber extends Validator {
  ValidatorNumber(String? value) : super(value);

  ValidatorNumber between(int min, int max, {required String errMsg}) {
    if (errorMessage != null) return this;
    if (value != null) {
      int intValue = int.tryParse(value!) ?? 0;
      if (intValue < min || intValue > max) {
        errorMessage = errMsg;
      }
    }
    return this;
  }
}

class ValidatorString extends Validator {
  ValidatorString(String? value) : super(value);

  ValidatorString isNotEmpty({required String errMsg}) {
    if (errorMessage != null) return this;
    if (value == null || value!.isEmpty) {
      errorMessage = errMsg;
    }
    return this;
  }

  ValidatorString email({required String errMsg}) {
    if (errorMessage != null) return this;
    if (value != null &&
        !RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value!)) {
      errorMessage = errMsg;
    }
    return this;
  }

  ValidatorString ipAddress({required String errMsg}) {
    if (errorMessage != null) return this;
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
        ipv4RegExp.hasMatch(value!) || ipv6RegExp.hasMatch(value!);

    if (!isValid) {
      errorMessage = errMsg;
    }

    return this;
  }
}

class MDNValidator {
  static String? validateUUID(String? uuid) {
    return ValidatorString(uuid)
        .isNotEmpty(errMsg: "UUID nie może być pusty")
        .isUUID(errMsg: "Niepoprawny UUID")
        .build();
  }

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

  static String? validateBio(String? bio) {
    return ValidatorString(bio)
        .length(
          min: 0,
          max: 100,
          errMsg: "Biogram musi mieć maksymalnie 100 znaków",
        )
        .build();
  }

  static String? validateCatalogName(String? catalogName) {
    return ValidatorString(catalogName)
        .isNotEmpty(errMsg: "Nazwa folderu nie może być pusta")
        .length(
          min: 3,
          max: 256,
          errMsg: "Nazwa folderu musi mieć od 3 do 256 znaków",
        )
        .build();
  }

  static String? validateNoteTitle(String? noteTitle) {
    return ValidatorString(noteTitle)
        .isNotEmpty(errMsg: "Tytuł notatki nie może być pusty")
        .length(
          min: 3,
          max: 256,
          errMsg: "Tytuł notatki musi mieć od 3 do 256 znaków",
        )
        .build();
  }

  static String? validateNoteTagTitle(String? noteTagTitle) {
    return ValidatorString(noteTagTitle)
        .isNotEmpty(errMsg: "Tytuł tagu nie może być pusty")
        .length(
          min: 2,
          max: 10,
          errMsg: "Tytuł tagu musi mieć od 2 do 10 znaków",
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
  ValidatorNumber(super.value);

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
  ValidatorString(super.value);

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

  ValidatorString isUUID({required String errMsg}) {
    if (errorMessage != null) return this;
    if (value != null &&
        !RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
            .hasMatch(value!)) {
      errorMessage = errMsg;
    }
    return this;
  }
}

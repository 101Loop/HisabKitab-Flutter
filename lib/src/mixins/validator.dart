class ValidationMixin {
  /// Validates password
  String validatePassword(String value) {
    if (value == null || value.trim().isEmpty) {
      return 'isEmpty';
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'invalidPasswordMessage';
    } else {
      return null;
    }
  }

  /// Validates email
  String validateEmail(String value) {
    if (value == null || value.trim().isEmpty) {
      return 'isEmpty';
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'invalidEmail';
    } else {
      return null;
    }
  }

  /// Validates if the field is empty or not
  String validateField(String value) {
    String result = validateNonEmoji(value);
    if (result != null) return result;

    if (value.length < 1) {
      return 'isEmpty';
    } else {
      return null;
    }
  }

  /// Validates the length of the OTP
  String validateOTPLength(String value) {
    String result = validateNonEmoji(value);
    if (result != null) return result;

    if (value.length < 7) {
      return 'isValidOTPLength';
    } else {
      return null;
    }
  }

  /// Validates mobile number
  String validateMobile(String value) {
    if (value == null || value.trim().isEmpty) {
      return 'isEmpty';
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'isValidMobileMessage';
    } else {
      return null;
    }
  }

  /// Validates double value
  String validateDoubleValue(String value) {
    if (value == null || value.trim().isEmpty) {
      return 'isEmpty';
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    try {
      double _value = double.parse(value);

      if (_value < 0)
        return 'isSmallValue';
      else if (_value.toString().length > 20) return 'isLargeValue';
    } on FormatException catch (_) {
      return 'isValidValue';
    }

    String pattern = r'^\d+\.\d*|\.?\d+';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'isValidValue';
    } else {
      return null;
    }
  }

  /// Validates either the value is null or a valid double value
  String validateNullableDoubleValue(String value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    try {
      double _value = double.parse(value);

      if (_value < 0) return 'isSmallValue';
    } on FormatException catch (_) {
      return 'isValidValue';
    }

    String pattern = r'^\d+\.\d*|\.?\d+';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'isValidValue';
    } else {
      return null;
    }
  }

  /// Validates if non-emoji is entered or not
  ///
  /// returns null for non-emoji value
  static String validateNonEmoji(String value) {
    if (value == null || value.trim().isEmpty) {
      return 'isEmpty';
    }

    String pattern =
        r'^(?:(?!(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|\ud83c[\ude32-\ude3a]|\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff]))[^`☺]){1,255}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'isEmojiMessage';
    } else {
      return null;
    }
  }
}

class ValidationMixin {
  static String invalidPasswordMessage =
      'Password must have minimum 8 characters, at least one letter, one special character(!@#\$%) and one number';
  static String isEmojiMessage = 'Please Enter a valid text';
  static String isValidMobileMessage = 'Please enter a valid mobile number';
  static String isValidValue = 'Please enter a valid value';
  static String isEmpty = 'This field can\'t be empty';
  static String isLargeValue = 'Please Enter a value below 9,999';
  static String isSmallValue = 'Please a value above 0';

  ///method to validate passwords
  String validatePassword(String value) {
    if (value == null || value.trim().isEmpty) {
      return isEmpty;
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    String pattern = r'^(?=[^\d_].*?\d)\w(\w|[!@#$%]){7,20}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return invalidPasswordMessage;
    } else {
      return null;
    }
  }

  ///method to validate email
  String validateEmail(String value) {
    if (value == null || value.trim().isEmpty) {
      return isEmpty;
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  ///method to validate email
  String validateNullableEmail(String value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  ///method to validate if the field is empty or not
  String validateField(String value) {
    String result = validateNonEmoji(value);
    if (result != null) return result;

    if (value.length < 1) {
      return isEmpty;
    } else {
      return null;
    }
  }

  ///method to validate mobile number
  String validateMobile(String value) {
    if (value == null || value.trim().isEmpty) {
      return isEmpty;
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return isValidMobileMessage;
    } else {
      return null;
    }
  }

  ///method to validate mobile number
  String validateNullableMobile(String value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return isValidMobileMessage;
    } else {
      return null;
    }
  }

  ///method to validate integer
  String validateTime(String value) {
    if (value == null || value.trim().isEmpty) {
      return isEmpty;
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    try {
      int _value = int.parse(value);
      if (_value < 1) return isSmallValue;
    } on FormatException catch (_) {
      return isValidValue;
    }

    String pattern = r'^\d{1,3}$';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return null;
    } else {
      return isValidValue;
    }
  }

  ///method to validate double value
  String validateDoubleValue(String value) {
    if (value == null || value.trim().isEmpty) {
      return isEmpty;
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    try {
      double _value = double.parse(value);

      if (_value < 0) return isSmallValue;
    } on FormatException catch (_) {
      return isValidValue;
    }

    String pattern = r'^\d+\.\d*|\.?\d+';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return isValidValue;
    } else {
      return null;
    }
  }

  ///method to validate double value
  String validateNullableDoubleValue(String value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    String result = validateNonEmoji(value);
    if (result != null) return result;

    try {
      double _value = double.parse(value);

      if (_value > 9999)
        return isLargeValue;
      else if (_value < 0) return isSmallValue;
    } on FormatException catch (_) {
      return isValidValue;
    }

    String pattern = r'^\d+\.\d*|\.?\d+';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return isValidValue;
    } else {
      return null;
    }
  }

  ///method to check if the string isn't an emoji
  static String validateNonEmoji(String value) {
    if (value == null || value.trim().isEmpty) {
      return isEmpty;
    }

    String pattern =
        r'^(?:(?!(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|\ud83c[\ude32-\ude3a]|\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff]))[^`☺]){1,255}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return isEmojiMessage;
    } else {
      return null;
    }
  }
}

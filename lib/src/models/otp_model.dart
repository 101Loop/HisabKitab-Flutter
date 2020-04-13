class OTPModel {
  final String email;
  final int otp;

  OTPModel(this.email, {this.otp});

  Map<String, String> toMap() {
    var map = Map<String, dynamic>();
    map['value'] = email;
    if (otp != null) map['otp'] = otp;

    return map;
  }
}

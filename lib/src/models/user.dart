import 'package:hisabkitab/utils/const.dart' as Key;

class User {
  String username;
  String password;
  String error;
  Data data;
  int statusCode;

  User({
    this.username,
    this.password,
    this.error,
    this.data,
    this.statusCode
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json[Key.username],
      password: json[Key.password],
      data: json['data'] != null ? new Data.fromJson(json['data']) : null,
      statusCode: 200
    );
  }

  factory User.withError(String error, {int statusCode = -1}) {
    return User(
      error: error,
      statusCode: statusCode
    );
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[Key.username] = this.username;
    map[Key.password] = this.password;

    return map;
  }
}

class Data {
  String session;
  String token;

  Data({this.session, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    session = json['session'];
    token = json['token'];
  }
}

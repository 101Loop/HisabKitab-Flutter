import 'package:hisabkitab/utils/const.dart' as Key;

class User {
  String username;
  String password;
  String error;
  Data data;

  User({
    this.username,
    this.password,
    this.error,
    this.data,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json[Key.username],
      password: json[Key.password],
      data: json['data'] != null ? new Data.fromJson(json['data']) : null,
    );
  }
  factory User.withError(String error) {
    return User(
      error: error,
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

import 'package:hisabkitab/utils/const.dart' as Keys;

class UserAccount {
  Data data;
  String error;
  int statusCode;

  UserAccount({this.data, this.error, this.statusCode});

  UserAccount.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    statusCode = 200;
  }

  factory UserAccount.withError(String error, {int statusCode = -1}) {
    return UserAccount(error: error, statusCode: statusCode);
  }
}

class Data {
  String name;
  String username;
  String email;
  String mobile;
  String password;

  Data({this.name, this.username, this.email, this.mobile, this.password});

  Data.fromJson(Map<String, dynamic> json) {
    name = json[Keys.name];
    username = json[Keys.username];
    email = json[Keys.email];
    mobile = json[Keys.mobile];
    password = json[Keys.password];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[Keys.name] = this.name;
    data[Keys.username] = this.username;
    data[Keys.email] = this.email;
    data[Keys.mobile] = this.mobile;
    data[Keys.password] = this.password;
    return data;
  }
}

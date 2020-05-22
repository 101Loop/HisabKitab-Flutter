import 'package:hisabkitab/utils/const.dart' as Key;

/// Model class for [User].
///
/// Represents the user's login details
class User {
  /// Unique username of the user, can be either email or username
  final String username;

  /// Password of the user's account
  final String password;

  /// Represents the session and token data
  final Data data;

  /// Error, encountered while fetching the data from the server
  final String error;

  /// Status code of the response while fetching the data from the server
  final int statusCode;

  /// Constructor.
  User({this.username, this.password, this.error, this.data, this.statusCode});

  /// Returns [User] object from [json].
  factory User.fromJson(Map<String, dynamic> json) {
    return User(username: json[Key.username], password: json[Key.password], data: json['data'] != null ? new Data.fromJson(json['data']) : null, statusCode: 200);
  }

  /// Returns [User] object with an [error].
  factory User.withError(String error, {int statusCode = -1}) {
    return User(error: error, statusCode: statusCode);
  }

  /// Returns map representation of [User] object.
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[Key.username] = this.username;
    map[Key.password] = this.password;

    return map;
  }
}

/// Model class for [Data].
class Data {
  /// Unique identification of a logged in user
  String token;

  /// Constructor.
  Data({this.token});

  /// Returns [Data] object from [json].
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json['token'],
    );
  }
}

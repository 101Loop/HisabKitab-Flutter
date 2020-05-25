import 'package:equatable/equatable.dart';
import 'package:hisabkitab/utils/const.dart' as Keys;

/// Model class for [UserAccount].
///
/// Represents the user's account
class UserAccount extends Equatable {
  /// User account's data having account related details
  final Data data;

  /// Error, encountered while fetching the response from the server
  final String error;

  /// Response code while fetching the data from the server
  final int statusCode;

  /// Constructor.
  UserAccount({this.data, this.error, this.statusCode});

  /// Returns [UserAccount] object from [json].
  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      data: json['data'] != null ? new Data.fromJson(json['data']) : null,
      statusCode: 200,
    );
  }

  /// Returns [UserAccount] object wight [error].
  factory UserAccount.withError(String error, {int statusCode = -1}) {
    return UserAccount(error: error, statusCode: statusCode);
  }

  @override
  List<Object> get props => [data, error, statusCode];
}

/// Model class for [Data].
///
/// Represents some basic details of the user's account
class Data extends Equatable {
  final String name;
  final String username;
  final String email;
  final String mobile;
  final String password;

  /// Constructor.
  Data({this.name, this.username, this.email, this.mobile, this.password});

  /// Returns [Data] object from [json].
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json[Keys.name],
      username: json[Keys.username],
      email: json[Keys.email],
      mobile: json[Keys.mobile],
      password: json[Keys.password],
    );
  }

  /// Returns map representation of [Data] object.
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[Keys.name] = this.name;
    data[Keys.username] = this.username;
    data[Keys.email] = this.email;
    data[Keys.mobile] = this.mobile;
    data[Keys.password] = this.password;
    return data;
  }

  @override
  List<Object> get props => [name, username, email, mobile, password];
}

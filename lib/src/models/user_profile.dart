import 'package:equatable/equatable.dart';

/// Model class for [UserProfile].
///
/// Represents user's profile
class UserProfile extends Equatable {
  /// Unique id of the user
  final int id;

  /// Basic details of the user
  final String name;
  final String email;
  final String mobile;

  /// Status code of the response
  final int statusCode;

  /// Error, encountered while fetching the response
  final String error;

  /// Constructor.
  UserProfile({this.id, this.name, this.email, this.mobile, this.statusCode, this.error});

  /// Returns [UserProfile] object from [json].
  factory UserProfile.fromJson(var json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      statusCode: 200,
    );
  }

  /// Returns map representation of [UserProfile] object.
  Map<String, String> toMap() {
    var map = Map<String, String>();

    if (name?.isNotEmpty ?? false) map['name'] = name;
    if (email?.isNotEmpty ?? false) map['email'] = email;
    if (mobile?.isNotEmpty ?? false) map['mobile'] = mobile;

    return map;
  }

  @override
  List<Object> get props => [id, name, email, mobile, statusCode, error];
}

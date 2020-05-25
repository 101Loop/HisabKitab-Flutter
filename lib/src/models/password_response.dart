import 'package:equatable/equatable.dart';

/// Model class for [PasswordResponse].
class PasswordResponse extends Equatable {
  /// Status of the response, Ex: updated, not updated etc.
  final String data;

  /// Status code of the response, while fetching the data from the server
  final int statusCode;

  /// Constructor.
  PasswordResponse({this.data, this.statusCode});

  factory PasswordResponse.fromJson(var json) {
    return PasswordResponse(data: json['data'], statusCode: json['statusCode']);
  }

  @override
  List<Object> get props => [data, statusCode];
}

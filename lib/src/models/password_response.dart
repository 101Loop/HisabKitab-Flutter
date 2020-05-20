/// Model class for [PasswordResponse].
class PasswordResponse {
  /// Status of the response, Ex: updated, not updated etc.
  final String data;

  /// Status code of the response, while fetching the data from the server
  final int statusCode;

  /// Constructor.
  PasswordResponse({this.data, this.statusCode});
}

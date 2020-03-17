import 'dart:convert';

import 'package:hisabkitab/main.dart';
import 'package:hisabkitab/src/models/user.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:http/http.dart' as http;

class LoginAPIConroller {
  static String _token;

  /// api call to login the user

  static Future<User> login(User user) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var response;

    try {
      response = await http.post(Constants.LOGIN_URL, headers: headers, body: json.encode(user.toMap()));
    } catch (_) {
      return User(error: Constants.serverError);
    }

    int statusCode = response.statusCode;

    if (statusCode == Constants.HTTP_200_OK) {
      String responseBody = response.body.toString();
      var parsedResponse = json.decode(responseBody);

      // String token = parsedResponse['token'];
      // _saveToken(token
      // print(token);

      User user = User.fromJson(parsedResponse);
      _token = user.data.token;
      _saveToken(_token);
      print(_token);
      return user;
    } else {
      String errorMessage = response.body.toString();
      if (errorMessage != null) {
        try {
          var errorResponse = json.decode(errorMessage);

          if (errorResponse['detail'] != null) {
            var detail = errorResponse['detail'];
            return User(error: detail.toString());
          } else if (errorResponse['data'] != null) {
            var data = errorResponse['data'];
            var dataObject = json.encode(data);
            var parsedData = json.decode(dataObject);
            var nonFieldErrors = parsedData['non_field_errors'];
            if (nonFieldErrors != null) {
              String message = nonFieldErrors[0];
              return User(error: message);
            }
          }
        } catch (e) {
          return User(error: e.toString());
        }
      }
      return User(error: Constants.serverError);
    }
  }

  static _saveToken(String token) async {
//    await prefs.remove(Constants.TOKEN);
    await prefs.setString(Constants.TOKEN, token);
  }
}

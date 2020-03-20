import 'dart:convert';

import 'package:hisabkitab/main.dart';
import 'package:hisabkitab/src/models/password_response.dart';
import 'package:hisabkitab/src/models/user.dart';
import 'package:hisabkitab/src/models/user_profile.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:http/http.dart' as http;

class LoginAPIController {
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

  /// api call to get user profile
  static Future<UserProfile> getUserProfile() async {
    _token = _token ?? prefs.getString(Constants.TOKEN);

    Map<String, String> headers = {"Content-Type": "application/json", "Authorization": _token};

    var response;

    try {
      response = await http.get(Constants.LOGIN_URL, headers: headers);
    } catch (_) {
      return UserProfile(error: Constants.serverError);
    }

    int statusCode = response.statusCode;

    if (statusCode == Constants.HTTP_200_OK) {
      String responseBody = response.body.toString();
      var parsedResponse = json.decode(responseBody);
      return UserProfile.fromJson(parsedResponse);
    } else {
      String errorMessage = response.body.toString();
      if (errorMessage != null) {
        try {
          var errorResponse = json.decode(errorMessage);

          if (errorResponse['detail'] != null) {
            var detail = errorResponse['detail'];
            return UserProfile(error: detail.toString());
          } else if (errorResponse['data'] != null) {
            var data = errorResponse['data'];
            var dataObject = json.encode(data);
            var parsedData = json.decode(dataObject);
            var nonFieldErrors = parsedData['non_field_errors'];
            if (nonFieldErrors != null) {
              String message = nonFieldErrors[0];
              return UserProfile(error: message);
            } else {
              return UserProfile(error: errorResponse);
            }
          } else {
            UserProfile(error: errorResponse);
          }
        } catch (e) {
          return UserProfile(error: e.toString());
        }
      } else {
        return UserProfile(error: Constants.serverError);
      }
      return UserProfile(error: Constants.serverError);
    }
  }

  /// api call to update password
  static Future<PasswordResponse> updatePassword(String password) async {
    _token = _token ?? prefs.getString(Constants.TOKEN);

    Map<String, String> headers = {"Content-Type": "application/json", "Authorization": _token};

    var response;

    try {
      response = await http.patch(Constants.UPDATE_PASSWORD_URL, headers: headers, body: json.encode({"new_password": password}));
    } catch (_) {
      return PasswordResponse(data: 'Something went wrong', statusCode: -1);
    }

    int statusCode = response.statusCode;

    if (statusCode == Constants.HTTP_202_ACCEPTED) {
      return PasswordResponse(data: 'Password updated successfully', statusCode: statusCode);
    } else {
      String errorMessage = response.body.toString();
      if (errorMessage != null) {
        try {
          var errorResponse = json.decode(errorMessage);

          if (errorResponse['detail'] != null) {
            var detail = errorResponse['detail'];
            return PasswordResponse(data: detail.toString(), statusCode: statusCode);
          } else if (errorResponse['data'] != null) {
            var data = errorResponse['data'];
            var dataObject = json.encode(data);
            var parsedData = json.decode(dataObject);
            var nonFieldErrors = parsedData['non_field_errors'];
            var error = parsedData['new_password'];
            if (nonFieldErrors != null) {
              String message = nonFieldErrors[0];
              return PasswordResponse(data: message, statusCode: statusCode);
            } else if (error != null) {
              return PasswordResponse(data: error[0].toString(), statusCode: statusCode);
            } else {
              return PasswordResponse(data: errorResponse.toString(), statusCode: statusCode);
            }
          } else {
            return PasswordResponse(data: errorResponse.toString(), statusCode: statusCode);
          }
        } catch (e) {
          return PasswordResponse(data: e.toString(), statusCode: statusCode);
        }
      } else {
        return PasswordResponse(data: Constants.serverError, statusCode: statusCode);
      }
    }
  }

  static _saveToken(String token) async {
    await prefs.setString(Constants.TOKEN, token);
  }
}

import 'dart:convert';
import 'package:hisabkitab/src/models/user_account.dart';
import 'package:http/http.dart' as http;
import 'package:hisabkitab/utils/const.dart' as Constants;

class SignUpAPIController {
  ///api call to register user
  static Future<UserAccount> registerUser(UserAccount user) async {
    final Map<String, String> headers = {"Content-Type": "application/json"};

    var response;
    try {
      response = await http.post(
        Constants.REGISTER_URL,
        headers: headers,
        body: json.encode(
          user.data.toMap(),
        ),
      );
    } catch (_) {
      return UserAccount.withError(Constants.serverError);
    }

    final int statusCode = response.statusCode;

    if (statusCode == Constants.HTTP_201_CREATED) {
      var parsedResponse = json.decode(response.body);
      user = UserAccount.fromJson(parsedResponse);
      return user;
    } else {
      String errorMessage = response.body.toString();
      if (errorMessage != null) {
        try {
          var errorResponse = json.decode(errorMessage);

          if (errorResponse['detail'] != null) {
            var detail = errorResponse['detail'];
            return UserAccount.withError(detail.toString());
          } else if (errorResponse['data'] != null) {
            var data = errorResponse['data'];
            var dataObject = json.encode(data);
            var parsedData = json.decode(dataObject);
            var nonFieldErrors = parsedData['non_field_errors'];
            if (nonFieldErrors != null) {
              return UserAccount.withError('Email or Mobile already used');
            }
          }
        } catch (e) {
          return UserAccount.withError(e.toString());
        }
      }
      // return UserAccount.withError(errorMessage);
      return UserAccount.withError('Email or Mobile already used');
    }
  }
}

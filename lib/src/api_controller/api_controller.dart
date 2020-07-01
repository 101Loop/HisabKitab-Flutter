import 'dart:convert';

import 'package:hisabkitab/src/models/paginated_response.dart';
import 'package:hisabkitab/src/models/password_response.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/models/user.dart';
import 'package:hisabkitab/src/models/user_account.dart';
import 'package:hisabkitab/src/models/user_profile.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:hisabkitab/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

/// API controller class
class APIController {
  /// HTTP client, APIs will be called using this, makes easy to mock APIs
  static http.Client client = http.Client();

  /// Calls login API
  static Future<User> login(User user) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var response;

    try {
      response = await client.post(Constants.LOGIN_URL, headers: headers, body: json.encode(user.toMap()));
    } catch (_) {
      return User(error: 'serverError', statusCode: 0);
    }

    int statusCode = response.statusCode;
    String responseBody = response.body;

    print('login response: ' + responseBody);
    if (statusCode == Constants.HTTP_200_OK) {
      var parsedResponse = json.decode(responseBody);

      User user = User.fromJson(parsedResponse);
      String _token = user.data.token;
      SharedPrefs.saveToken(_token);
      return user;
    } else {
      if (responseBody != null) {
        try {
          var errorResponse = json.decode(responseBody);

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
      return User(error: 'serverError', statusCode: 0);
    }
  }

  /// Calls user profile API
  static Future<UserProfile> getUserProfile() async {
    Map<String, String> headers = {"Content-Type": "application/json", "Authorization": SharedPrefs.token};

    var response;

    try {
      response = await client.get(Constants.PROFILE_URL, headers: headers);
    } catch (_) {
      return UserProfile(error: 'serverError', statusCode: 0);
    }

    int statusCode = response.statusCode;

    String responseBody = response.body;
    print('user profile response: ' + responseBody);
    if (statusCode == Constants.HTTP_200_OK) {
      var parsedResponse = json.decode(responseBody);
      return UserProfile.fromJson(parsedResponse[0]);
    } else {
      if (responseBody != null) {
        try {
          var errorResponse = json.decode(responseBody);
          if (errorResponse is String)
            return UserProfile(error: errorResponse, statusCode: statusCode);
          else if (errorResponse is List) return UserProfile(error: errorResponse[0]);

          final errorValues = errorResponse.entries;
          if (errorValues.length > 0) {
            for (MapEntry entry in errorValues) {
              String error = entry.value is String ? entry.value : entry.value[0];
              return UserProfile(error: entry.key + ': ' + error, statusCode: statusCode);
            }
          }
        } catch (e) {
          return UserProfile(error: e.toString());
        }
      } else {
        return UserProfile(error: 'serverError', statusCode: 0);
      }
      return UserProfile(error: 'serverError', statusCode: 0);
    }
  }

  /// Updates user profile
  static Future<UserProfile> updateUserProfile(UserProfile data) async {
    Map<String, String> headers = {"Content-Type": "application/json", "Authorization": SharedPrefs.token};

    var response;

    try {
      response = await client.patch(Constants.UPDATE_PROFILE_URL, headers: headers, body: json.encode(data.toMap()));
    } catch (_) {
      return UserProfile(error: 'serverError', statusCode: 0);
    }

    int statusCode = response.statusCode;

    String responseBody = response.body;
    print('update user profile response: ' + responseBody);
    if (statusCode == Constants.HTTP_200_OK || statusCode == Constants.HTTP_202_ACCEPTED) {
      var parsedResponse = json.decode(responseBody);
      return UserProfile.fromJson(parsedResponse['data']);
    } else {
      if (responseBody != null) {
        try {
          var errorResponse = json.decode(responseBody);
          if (errorResponse is String)
            return UserProfile(error: errorResponse, statusCode: statusCode);
          else if (errorResponse is List) return UserProfile(error: errorResponse[0]);

          final errorValues = errorResponse.entries;
          if (errorValues.length > 0) {
            for (MapEntry entry in errorValues) {
              String error = entry.value is String ? entry.value : entry.value[0];
              return UserProfile(error: entry.key + ': ' + error, statusCode: statusCode);
            }
          }
        } on TypeError catch (_) {
          return UserProfile(error: responseBody);
        } catch (e) {
          return UserProfile(error: e.toString());
        }
      } else {
        return UserProfile(error: 'serverError', statusCode: 0);
      }
      return UserProfile(error: 'serverError', statusCode: 0);
    }
  }

  /// Updates password
  static Future<PasswordResponse> updatePassword(String password) async {
    Map<String, String> headers = {"Content-Type": "application/json", "Authorization": SharedPrefs.token};

    var response;

    try {
      response = await client.patch(Constants.UPDATE_PASSWORD_URL, headers: headers, body: json.encode({"new_password": password}));
    } catch (_) {
      return PasswordResponse(data: 'somethingWentWrong', statusCode: 0);
    }

    int statusCode = response.statusCode;

    String responseBody = response.body;
    print('update password response: ' + responseBody);
    if (statusCode == Constants.HTTP_202_ACCEPTED) {
      return PasswordResponse(data: 'passwordUpdatedSuccessfully', statusCode: statusCode);
    } else {
      if (responseBody != null) {
        try {
          var errorResponse = json.decode(responseBody);
          if (errorResponse is String)
            return PasswordResponse(data: errorResponse, statusCode: statusCode);
          else if (errorResponse is List) return PasswordResponse(data: errorResponse[0]);

          final errorValues = errorResponse.entries;
          if (errorValues.length > 0) {
            for (MapEntry entry in errorValues) {
              String error = entry.value is String ? entry.value : entry.value[0];
              return PasswordResponse(data: entry.key + ': ' + error, statusCode: statusCode);
            }
          }
          return PasswordResponse(data: 'serverError', statusCode: 0);
        } catch (e) {
          return PasswordResponse(data: e.toString(), statusCode: statusCode);
        }
      } else {
        return PasswordResponse(data: 'serverError', statusCode: 0);
      }
    }
  }

  ///api call to verify user
  static Future<PasswordResponse> getOtp(String email, {int otp}) async {
    final Map<String, String> headers = {"Content-Type": "application/json"};
    final Map<String, String> data = {"value": email};

    if (otp != null) data['otp'] = otp.toString();

    PasswordResponse apiResponse;

    var response;
    try {
      response = await client.post(Constants.LOGIN_OTP_URL, headers: headers, body: json.encode(data));
    } catch (_) {
      return PasswordResponse(data: 'serverError', statusCode: 0);
    }

    final int statusCode = response.statusCode;

    String responseBody = response.body;
    print('OTP response: ' + responseBody);
    if (statusCode == Constants.HTTP_201_CREATED || statusCode == Constants.HTTP_202_ACCEPTED) {
      var parsedResponse = json.decode(responseBody);
      apiResponse = PasswordResponse(data: parsedResponse['data']['message'], statusCode: statusCode);
      return apiResponse;
    } else if (statusCode == Constants.HTTP_200_OK) {
      var parsedResponse = json.decode(responseBody);
      apiResponse = PasswordResponse(data: parsedResponse['data']['token'], statusCode: statusCode);
      return apiResponse;
    } else {
      if (responseBody != null) {
        try {
          var errorResponse = json.decode(responseBody);
          if (errorResponse is String)
            return PasswordResponse(data: errorResponse, statusCode: statusCode);
          else if (errorResponse is List) return PasswordResponse(data: errorResponse[0]);

          if (errorResponse['detail'] != null) {
            var detail = errorResponse['detail'];
            return PasswordResponse(data: detail.toString(), statusCode: statusCode);
          } else if (errorResponse['data'] != null) {
            var data = errorResponse['data'];
            var dataObject = json.encode(data);
            var parsedData = json.decode(dataObject);
            var message = parsedData['message'];
            if (message != null) {
              return PasswordResponse(data: message, statusCode: statusCode);
            } else {
              var otpMessage = parsedData['OTP'];
              return PasswordResponse(data: otpMessage, statusCode: statusCode);
            }
          }
          return PasswordResponse(data: 'serverError', statusCode: 0);
        } catch (e) {
          return PasswordResponse(data: e.toString(), statusCode: statusCode);
        }
      }
      return PasswordResponse(data: responseBody, statusCode: statusCode);
    }
  }

  /// Registers user
  static Future<UserAccount> registerUser(UserAccount user) async {
    final Map<String, String> headers = {"Content-Type": "application/json"};

    var response;
    try {
      response = await client.post(
        Constants.REGISTER_URL,
        headers: headers,
        body: json.encode(
          user.data.toMap(),
        ),
      );
    } catch (_) {
      return UserAccount.withError('serverError', statusCode: 0);
    }

    final int statusCode = response.statusCode;
    String responseBody = response.body;
    print('register user response: ' + response.body);

    if (statusCode == Constants.HTTP_201_CREATED) {
      var parsedResponse = json.decode(responseBody);
      user = UserAccount.fromJson(parsedResponse);
      return user;
    } else {
      if (responseBody != null) {
        try {
          var errorResponse = json.decode(responseBody);
          if (errorResponse is String)
            return UserAccount.withError(errorResponse, statusCode: statusCode);
          else if (errorResponse is List) return UserAccount.withError(errorResponse[0]);

          final errorData = errorResponse['data'];
          final errorValues = errorData.entries;
          if (errorValues.length > 0) {
            for (MapEntry entry in errorValues) {
              String error = entry.value is String ? entry.value : entry.value[0];

              if (error.contains('exists'))
                error = 'alreadyExistingError';

              return UserAccount.withError(error, statusCode: statusCode);
            }
          }
        } catch (e) {
          return UserAccount.withError(e.toString());
        }
      }
      return UserAccount.withError('alreadyExistingError', statusCode: 0);
    }
  }

  /// Gets transaction list
  static Future<PaginatedResponse> getTransaction(String queryParams, {String next}) async {
    //removes &, if present at last
    if (queryParams.endsWith("\&")) {
      queryParams = queryParams.substring(0, queryParams.length - 1);
    }

    //when there's nothing in query param, make the query param empty
    if (queryParams.length == 1) {
      queryParams = '';
    }

    print('query params: $queryParams');

    final Map<String, String> headers = {"Content-Type": "application/json", "Authorization": SharedPrefs.token};

    var response;
    try {
      response = await client.get(next ?? Constants.GET_TRANSACTION_URL + queryParams, headers: headers);
    } catch (_) {
      return PaginatedResponse.withError('serverError', statusCode: 0);
    }

    final int statusCode = response.statusCode;

    String responseBody = response.body;
    print('get transaction response: ' + response.body);

    if (statusCode == Constants.HTTP_200_OK) {
      var parsedResponse = json.decode(responseBody);
      return PaginatedResponse.fromJson(parsedResponse);
    } else {
      if (responseBody != null) {
        try {
          var errorResponse = json.decode(responseBody);
          if (errorResponse is String)
            return PaginatedResponse.withError(errorResponse, statusCode: statusCode);
          else if (errorResponse is List) return PaginatedResponse.withError(errorResponse[0], statusCode: statusCode);

          final errorValues = errorResponse.entries;
          if (errorValues.length > 0) {
            for (MapEntry entry in errorValues) {
              String error = entry.value is String ? entry.value : entry.value[0];
              return PaginatedResponse.withError(entry.key + ': ' + error, statusCode: statusCode);
            }
          }
        } catch (e) {
          return PaginatedResponse.withError(e.toString(), statusCode: statusCode);
        }
      }
      return PaginatedResponse.withError(responseBody, statusCode: statusCode);
    }
  }

  /// Adds or updates a transaction
  static Future<TransactionDetails> addUpdateTransaction(TransactionDetails data, int id) async {
    final Map<String, String> headers = {"Content-Type": "application/json", "Authorization": SharedPrefs.token};

    var response;
    try {
      if (id == -1) {
        response = await client.post(Constants.ADD_TRANSACTION_URL, headers: headers, body: json.encode(data.toMap()));
      } else {
        response = await client.patch(Constants.TRANSACTION_URL + '$id/update/', headers: headers, body: json.encode(data.toMap()));
      }
    } catch (_) {
      return TransactionDetails.withError('serverError', statusCode: 0);
    }

    final int statusCode = response.statusCode;

    String responseBody = response.body;
    print('add/update transaction response: ' + response.body);
    if (statusCode == Constants.HTTP_201_CREATED || statusCode == Constants.HTTP_200_OK) {
      var parsedResponse = json.decode(responseBody);
      return TransactionDetails.fromJson(parsedResponse, message: id != -1 ? 'transactionUpdatedSuccessful' : 'transactionAddedSuccessful');
    } else {
      if (responseBody != null) {
        try {
          var errorResponse = json.decode(responseBody);
          if (errorResponse is String)
            return TransactionDetails.withError(errorResponse, statusCode: statusCode);
          else if (errorResponse is List) return TransactionDetails.withError(errorResponse[0], statusCode: statusCode);

          final errorValues = errorResponse.entries;
          if (errorValues.length > 0) {
            for (MapEntry entry in errorValues) {
              String error = entry.value is String ? entry.value : entry.value[0];
              return TransactionDetails.withError(entry.key + ': ' + error, statusCode: statusCode);
            }
          }
          return TransactionDetails.withError('somethingWentWrong', statusCode: statusCode);
        } catch (e) {
          return TransactionDetails.withError(e.toString());
        }
      } else
        return TransactionDetails.withError('somethingWentWrong', statusCode: 0);
    }
  }

  /// Deletes transaction
  static void deleteTransaction(int transactionId) async {
    final Map<String, String> headers = {"Content-Type": "application/json", "Authorization": SharedPrefs.token};
    try {
      final response = await client.delete(Constants.TRANSACTION_URL + '$transactionId' + '/delete/', headers: headers);

      print('delete transaction response: ' + response.body);
    } catch (_) {
      return;
    }
  }
}

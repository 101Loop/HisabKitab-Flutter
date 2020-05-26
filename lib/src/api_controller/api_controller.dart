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
  /// Calls login API
  static Future<User> login(User user) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var response;

    try {
      response = await http.post(Constants.LOGIN_URL, headers: headers, body: json.encode(user.toMap()));
    } catch (_) {
      return User(error: 'serverError', statusCode: 0);
    }

    int statusCode = response.statusCode;

    if (statusCode == Constants.HTTP_200_OK) {
      String responseBody = response.body.toString();
      var parsedResponse = json.decode(responseBody);

      User user = User.fromJson(parsedResponse);
      String _token = user.data.token;
      SharedPrefs.saveToken(_token);
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
      return User(error: 'serverError', statusCode: 0);
    }
  }

  /// Calls user profile API
  static Future<UserProfile> getUserProfile() async {
    Map<String, String> headers = {"Content-Type": "application/json", "Authorization": SharedPrefs.token};

    var response;

    try {
      response = await http.get(Constants.PROFILE_URL, headers: headers);
    } catch (_) {
      return UserProfile(error: 'serverError', statusCode: 0);
    }

    int statusCode = response.statusCode;

    if (statusCode == Constants.HTTP_200_OK) {
      String responseBody = response.body.toString();
      var parsedResponse = json.decode(responseBody);
      return UserProfile.fromJson(parsedResponse[0]);
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
      response = await http.patch(Constants.UPDATE_PROFILE_URL, headers: headers, body: json.encode(data.toMap()));
    } catch (_) {
      return UserProfile(error: 'serverError', statusCode: 0);
    }

    int statusCode = response.statusCode;

    if (statusCode == Constants.HTTP_200_OK || statusCode == Constants.HTTP_202_ACCEPTED) {
      String responseBody = response.body.toString();
      var parsedResponse = json.decode(responseBody);
      return UserProfile.fromJson(parsedResponse['data']);
    } else {
      String errorMessage = response.body.toString();
      if (errorMessage != null) {
        try {
          var errorResponse = json?.decode(errorMessage);

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
        } on TypeError catch (_) {
          return UserProfile(error: errorMessage);
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
      response = await http.patch(Constants.UPDATE_PASSWORD_URL, headers: headers, body: json.encode({"new_password": password}));
    } catch (_) {
      return PasswordResponse(data: 'somethingWentWrong', statusCode: 0);
    }

    int statusCode = response.statusCode;

    if (statusCode == Constants.HTTP_202_ACCEPTED) {
      return PasswordResponse(data: 'passwordUpdatedSuccessfully', statusCode: statusCode);
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
        return PasswordResponse(data: 'serverError', statusCode: 0);
      }
    }
  }

  ///api call to verify user
  static Future<PasswordResponse> getOtp(String email, {int otp}) async {
    final Map<String, String> headers = {"Content-Type": "application/json"};
    final Map<String, String> data = {"value": email};

    if (otp != null)
      data['otp'] = otp.toString();

    PasswordResponse apiResponse;

    var response;
    try {
      response = await http.post(Constants.LOGIN_OTP_URL, headers: headers, body: json.encode(data));
    } catch (_) {
      return PasswordResponse(data: 'serverError', statusCode: 0);
    }

    final int statusCode = response.statusCode;

    if (statusCode == Constants.HTTP_201_CREATED || statusCode == Constants.HTTP_202_ACCEPTED) {
      var parsedResponse = json.decode(response.body);
      apiResponse = PasswordResponse(data: parsedResponse['data']['message'], statusCode: statusCode);
      return apiResponse;
    } else if (statusCode == Constants.HTTP_200_OK) {
      var parsedResponse = json.decode(response.body);
      apiResponse = PasswordResponse(data: parsedResponse['data']['token'], statusCode: statusCode);
      return apiResponse;
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
            var message = parsedData['message'];
            if (message != null) {
              return PasswordResponse(data: message, statusCode: statusCode);
            } else {
              var otpMessage = parsedData['OTP'];
              return PasswordResponse(data: otpMessage, statusCode: statusCode);
            }
          }
        } catch (e) {
          return PasswordResponse(data: e.toString(), statusCode: statusCode);
        }
      }
      return PasswordResponse(data: errorMessage, statusCode: statusCode);
    }
  }

  /// Registers user
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
      return UserAccount.withError('serverError', statusCode: 0);
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
              return UserAccount.withError('alreadyExistingError', statusCode: 0);
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
      response = await http.get(next ?? Constants.GET_TRANSACTION_URL + queryParams, headers: headers);
    } catch (_) {
      return PaginatedResponse.withError('serverError', statusCode: 0);
    }

    final int statusCode = response.statusCode;

    if (statusCode == Constants.HTTP_200_OK) {
      var parsedResponse = json.decode(response.body);
      return PaginatedResponse.fromJson(parsedResponse);
    } else {
      String errorMessage = response.body.toString();
      if (errorMessage != null) {
        try {
          var errorResponse = json.decode(errorMessage);

          if (errorResponse['detail'] != null) {
            var detail = errorResponse['detail'];
            return PaginatedResponse.withError(detail.toString());
          } else if (errorResponse['data'] != null) {
            var data = errorResponse['data'];
            var dataObject = json.encode(data);
            var parsedData = json.decode(dataObject);
            var nonFieldErrors = parsedData['non_field_errors'];
            if (nonFieldErrors != null) {
              return PaginatedResponse.withError(nonFieldErrors[0].toString());
            }
          }
        } catch (e) {
          return PaginatedResponse.withError(e.toString());
        }
      }
      return PaginatedResponse.withError(errorMessage);
    }
  }

  /// Adds or updates a transaction
  static Future<TransactionDetails> addUpdateTransaction(TransactionDetails data, int id) async {
    final Map<String, String> headers = {"Content-Type": "application/json", "Authorization": SharedPrefs.token};

    var response;
    try {
      if (id == -1) {
        response = await http.post(Constants.ADD_TRANSACTION_URL, headers: headers, body: json.encode(data.toMap()));
      } else {
        response = await http.patch(Constants.TRANSACTION_URL + '$id/update/', headers: headers, body: json.encode(data.toMap()));
      }
    } catch (_) {
      return TransactionDetails.withError('serverError', statusCode: 0);
    }

    final int statusCode = response.statusCode;

    if (statusCode == Constants.HTTP_201_CREATED || statusCode == Constants.HTTP_200_OK) {
      var parsedResponse = json.decode(response.body);
      return TransactionDetails.fromJson(parsedResponse, message: id != -1 ? 'transactionUpdatedSuccessful' : 'transactionAddedSuccessful');
    } else {
      String errorMessage = response.body.toString();
      if (errorMessage != null) {
        try {
          var errorResponse = json.decode(errorMessage);

          if (errorResponse['detail'] != null) {
            var detail = errorResponse['detail'];
            return TransactionDetails.withError(detail.toString());
          } else if (errorResponse['data'] != null) {
            var data = errorResponse['data'];
            var dataObject = json.encode(data);
            var parsedData = json.decode(dataObject);
            var nonFieldErrors = parsedData['non_field_errors'];
            if (nonFieldErrors != null) {
              return TransactionDetails.withError(nonFieldErrors);
            } else {
              return TransactionDetails.withError('somethingWentWrong', statusCode: 0);
            }
          } else if (errorResponse['mode'] != null) {
            return TransactionDetails.withError(errorResponse['mode'][0]);
          } else {
            return TransactionDetails.withError(errorMessage);
          }
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
      http.delete(Constants.TRANSACTION_URL + '$transactionId' + '/delete/', headers: headers);
    } catch (_) {
      return;
    }
  }
}

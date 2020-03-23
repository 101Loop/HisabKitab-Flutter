import 'dart:convert';
import 'package:hisabkitab/src/models/paginated_response.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:hisabkitab/utils/utility.dart';
import 'package:http/http.dart' as http;

class TransactionApiController {
  ///api call to fetch transaction details
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

    final Map<String, String> headers = {"Content-Type": "application/json", "Authorization": Utility.token};

    var response;
    try {
      response = await http.get(next ?? Constants.GET_TRANSACTION_URL + queryParams, headers: headers);
    } catch (_) {
      return PaginatedResponse.withError(Constants.serverError);
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
              return PaginatedResponse.withError('Email or Mobile already used');
            }
          }
        } catch (e) {
          return PaginatedResponse.withError(e.toString());
        }
      }
      return PaginatedResponse.withError('Email or Mobile already used');
    }
  }

  ///api call to add transaction details
  static Future<TransactionDetails> addUpdateTransaction(TransactionDetails data, int id) async {
    final Map<String, String> headers = {"Content-Type": "application/json", "Authorization": Utility.token};

    var response;
    try {
      if (id == -1) {
        response = await http.post(Constants.ADD_TRANSACTION_URL, headers: headers, body: json.encode(data.toMap()));
      } else {
        response = await http.patch(Constants.TRANSACTION_URL + '$id/update/', headers: headers, body: json.encode(data.toMap()));
      }
    } catch (_) {
      return TransactionDetails.withError(Constants.serverError);
    }

    final int statusCode = response.statusCode;

    if (statusCode == Constants.HTTP_201_CREATED || statusCode == Constants.HTTP_200_OK) {
      var parsedResponse = json.decode(response.body);
      return TransactionDetails.fromJson(parsedResponse, message: id != -1 ? 'Transaction updated successfully' : 'Transaction added successfully');
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
              return TransactionDetails.withError('Something went wrong!, Please try again later');
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
        return TransactionDetails.withError('Something went wrong!, Please try again later');
    }
  }

  /// api call to delete the transaction
  static void deleteTransaction(int transactionId) async {
    final Map<String, String> headers = {"Content-Type": "application/json", "Authorization": Utility.token};
    try {
      http.delete(Constants.TRANSACTION_URL + '$transactionId' + '/delete/', headers: headers);
    } catch (_) {
      return;
    }
  }
}

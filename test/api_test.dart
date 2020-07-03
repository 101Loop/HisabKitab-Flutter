import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hisabkitab/src/api_controller/api_controller.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/models/user.dart';
import 'package:hisabkitab/src/models/user_account.dart' as userAccount;
import 'package:hisabkitab/src/models/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('login api test', () {
    test('login test, successful', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "data": {"session": "my_session", "token": "my_token"},
          "status_code": 200
        };
        return http.Response(json.encode(response), 200);
      });

      final User user = User(username: 'username', password: 'pass');
      final response = await APIController.login(user);
      expect(response.data.token, 'my_token');
    });

    test('login test, invalid credentials', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "data": {
            "non_field_errors": ["Unable to log in with provided credentials."]
          },
          "status_code": 422
        };
        return http.Response(json.encode(response), 422);
      });

      final User user = User(username: 'username', password: 'pass');
      final result = await APIController.login(user);
      expect(result.error, 'Unable to log in with provided credentials.');
    });
  });

  group('user profile API test', () {
    test('user profile test, successful', () async {
      APIController.client = MockClient((request) async {
        final response = [
          {"name": "sample name", "email": "example@gmail.com", "mobile": "9999999999"}
        ];
        return http.Response(json.encode(response), 200);
      });

      final result = await APIController.getUserProfile();
      expect(result.name, 'sample name');
      expect(result.email, 'example@gmail.com');
      expect(result.mobile, '9999999999');
    });

    test('user profile test, error string', () async {
      APIController.client = MockClient((request) async {
        final response = "Something went wrong";
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.getUserProfile();
      expect(result.error, 'Something went wrong');
    });

    test('user profile test, array of string error', () async {
      APIController.client = MockClient((request) async {
        final response = {
          'error': ['Something went wrong']
        };
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.getUserProfile();
      expect(result.error, 'error: Something went wrong');
    });

    test('user profile test, profile not found', () async {
      APIController.client = MockClient((request) async {
        final response = {'not_found': 'Profile not found'};
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.getUserProfile();
      expect(result.error, 'not_found: Profile not found');
    });

    test('user profile test, array of string error', () async {
      APIController.client = MockClient((request) async {
        final response = ['something went wrong'];
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.getUserProfile();
      expect(result.error, 'something went wrong');
    });

    test('user profile test, null response', () async {
      APIController.client = MockClient((request) async {
        return http.Response(null, 400);
      });

      final result = await APIController.getUserProfile();
      expect(result.error, 'serverError');
      expect(result.statusCode, 0);
    });
  });

  group('update user profile API test', () {
    UserProfile userProfile = UserProfile(name: 'name', email: 'example@gmail.com', mobile: '1234567890');

    test('update user profile test, successful', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "data": {"name": "sample name", "email": "example@gmail.com", "mobile": "9999999999"},
          "status_code": 202
        };
        return http.Response(json.encode(response), 202);
      });

      final result = await APIController.updateUserProfile(userProfile);
      expect(result.name, 'sample name');
      expect(result.email, 'example@gmail.com');
      expect(result.mobile, '9999999999');
    });

    test('user profile test, error string', () async {
      APIController.client = MockClient((request) async {
        final response = "Something went wrong";
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.updateUserProfile(userProfile);
      expect(result.error, 'Something went wrong');
    });

    test('user profile test, array of string error', () async {
      APIController.client = MockClient((request) async {
        final response = {
          'error': ['Something went wrong']
        };
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.updateUserProfile(userProfile);
      expect(result.error, 'error: Something went wrong');
    });

    test('user profile test, profile not found', () async {
      APIController.client = MockClient((request) async {
        final response = {'not_found': 'Profile not found'};
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.updateUserProfile(userProfile);
      expect(result.error, 'not_found: Profile not found');
    });

    test('user profile test, profile not found', () async {
      APIController.client = MockClient((request) async {
        final response = ["This email already exists"];
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.updateUserProfile(userProfile);
      expect(result.error, 'This email already exists');
    });

    test('user profile test, null response', () async {
      APIController.client = MockClient((request) async {
        return http.Response(null, 400);
      });

      final result = await APIController.updateUserProfile(userProfile);
      expect(result.error, 'serverError');
      expect(result.statusCode, 0);
    });
  });

  group('password update API test', () {
    test('password update test, successful', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "data": {"success": true},
          "status_code": 202
        };
        return http.Response(json.encode(response), 202);
      });

      final result = await APIController.updatePassword('pass');
      expect(result.data, 'passwordUpdatedSuccessfully');
      expect(result.statusCode, 202);
    });

    test('user profile test, error string', () async {
      APIController.client = MockClient((request) async {
        final response = "Something went wrong";
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.updatePassword('pass');
      expect(result.data, 'Something went wrong');
      expect(result.statusCode, 400);
    });

    test('password update test, array of string error', () async {
      APIController.client = MockClient((request) async {
        final response = {
          'error': ['Something went wrong']
        };
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.updatePassword('pass');
      expect(result.data, 'error: Something went wrong');
    });

    test('password update test, profile not found', () async {
      APIController.client = MockClient((request) async {
        final response = ["something went wrong"];
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.updatePassword('pass');
      expect(result.data, 'something went wrong');
    });

    test('password update, null response', () async {
      APIController.client = MockClient((request) async {
        return http.Response(null, 400);
      });

      final result = await APIController.updatePassword('pass');
      expect(result.data, 'somethingWentWrong');
      expect(result.statusCode, 0);
    });
  });

  group('OTP API test', () {
    test('OTP test, successful', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "data": {"session": "my_session", "token": "my_token"},
          "status_code": 200
        };
        return http.Response(json.encode(response), 200);
      });

      final result = await APIController.getOtp('example@email.com', otp: 1234567);
      expect(result.data, 'my_token');
      expect(result.statusCode, 200);
    });

    test('no user exists', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "data": {"success": false, "message": "No user exists with provided details!"},
          "status_code": 404
        };
        return http.Response(json.encode(response), 404);
      });

      final result = await APIController.getOtp('example@email.com');
      expect(result.data, 'No user exists with provided details!');
      expect(result.statusCode, 404);
    });

    test('wrong OTP provided', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "data": {"success": false, "OTP": "OTP Validation failed! 2 attempts left!"},
          "status_code": 401
        };
        return http.Response(json.encode(response), 401);
      });

      final result = await APIController.getOtp('pass@gmail.com', otp: 0123456);
      expect(result.data, 'OTP Validation failed! 2 attempts left!');
    });

    test('password update test, profile not found', () async {
      APIController.client = MockClient((request) async {
        final response = ["something went wrong"];
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.getOtp('example@email.com');
      expect(result.data, 'something went wrong');
    });

    test('password update, null response', () async {
      APIController.client = MockClient((request) async {
        return http.Response(null, 400);
      });

      final result = await APIController.getOtp('example@email.com');
      expect(result.data, 'serverError');
      expect(result.statusCode, 0);
    });
  });

  group('register API test', () {
    userAccount.UserAccount account = userAccount.UserAccount(
      data: userAccount.Data(
        name: 'name',
        mobile: '123',
        email: 'email@gmail.com',
        password: 'pass',
        username: 'username',
      ),
    );

    test('register test, successful', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "data": {"name": "name", "username": "username", "id": 1, "email": "email@gmail.com", "mobile": "123"},
          "status_code": 201
        };
        return http.Response(json.encode(response), 201);
      });

      final result = await APIController.registerUser(account);
      expect(result.data.name, 'name');
      expect(result.data.username, 'username');
      expect(result.data.email, 'email@gmail.com');
      expect(result.data.mobile, '123');
    });

    test('user already exists', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "data": {
            "mobile": ["User with this Mobile Number already exists."]
          },
          "status_code": 422
        };
        return http.Response(json.encode(response), 422);
      });

      final result = await APIController.registerUser(account);
      expect(result.error, 'alreadyExistingError');
      expect(result.statusCode, 422);
    });

    test('wrong data provided', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "data": {"email1": "invalid email provided"},
          "status_code": 400
        };
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.registerUser(account);
      expect(result.error, 'invalid email provided');
    });

    test('register user unknown error', () async {
      APIController.client = MockClient((request) async {
        final response = ["something went wrong"];
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.registerUser(account);
      expect(result.error, 'something went wrong');
    });

    test('null response', () async {
      APIController.client = MockClient((request) async {
        return http.Response(null, 400);
      });

      final result = await APIController.registerUser(account);
      expect(result.error, 'serverError');
      expect(result.statusCode, 0);
    });
  });

  group('transaction list API test', () {
    test('fetch list, 1 transaction', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "count": 1,
          "next": null,
          "previous": null,
          "results": [
            {
              "id": 1,
              "mode": {"id": 5, "mode": "Card"},
              "contact": {"id": 2, "name": "car repair", "email": null, "mobile": null},
              "transaction_date": "2020-05-22",
              "create_date": "2020-05-23T19:11:27.618964",
              "update_date": "2020-05-23T19:11:27.618985",
              "category": "D",
              "amount": 2500.0,
              "comments": null,
              "created_by": 3974
            }
          ],
          "total_amount": 2500.0
        };
        return http.Response(json.encode(response), 200);
      });

      final result = await APIController.getTransaction('');
      expect(result.results.length, 1);
      expect(result.statusCode, 200);
      expect(result.next, null);
      expect(result.previous, null);
      expect(result.count, 1);
      expect(result.totalAmount, 2500.0);
    });

    test('fetch list, 0 transaction', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "count": 0,
          "next": null,
          "previous": null,
          "results": [],
          "total_amount": 0,
        };
        return http.Response(json.encode(response), 200);
      });

      final result = await APIController.getTransaction('');
      expect(result.results.length, 0);
      expect(result.results, []);
      expect(result.statusCode, 200);
      expect(result.next, null);
      expect(result.previous, null);
      expect(result.count, 0);
      expect(result.totalAmount, 0);
    });

    test('array of string error', () async {
      APIController.client = MockClient((request) async {
        final response = ["something went wrong"];
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.getTransaction('');
      expect(result.error, 'something went wrong');
      expect(result.statusCode, 400);
    });

    test('string error', () async {
      APIController.client = MockClient((request) async {
        final response = "something went wrong";
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.getTransaction('');
      expect(result.error, 'something went wrong');
      expect(result.statusCode, 400);
    });

    test('json error', () async {
      APIController.client = MockClient((request) async {
        final response = {"error": "something went wrong"};
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.getTransaction('');
      expect(result.error, 'error: something went wrong');
      expect(result.statusCode, 400);
    });
  });

  group('add/update transaction API test', () {
    TransactionDetails transactionDetails = TransactionDetails();

    test('add/update transaction, successful', () async {
      APIController.client = MockClient((request) async {
        final response = {
          "mode": 2,
          "amount": 500.0,
          "transaction_date": "2020-05-23",
          "contact": "incentive",
          "category": "C",
          "comments": null,
        };
        return http.Response(json.encode(response), 200);
      });

      final result = await APIController.addUpdateTransaction(transactionDetails, 1);
      expect(result.mode, 2);
      expect(result.contact, 'incentive');
      expect(result.amount, 500.0);
      expect(result.transactionDate, '2020-05-23');
      expect(result.category, 'C');
      expect(result.comments, null);
      expect(result.statusCode, 200);
    });

    test('string error', () async {
      APIController.client = MockClient((request) async {
        final response = "something went wrong";
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.addUpdateTransaction(transactionDetails, 1);
      expect(result.message, 'something went wrong');
      expect(result.statusCode, 400);
    });

    test('array of string error', () async {
      APIController.client = MockClient((request) async {
        final response = ["something went wrong"];
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.addUpdateTransaction(transactionDetails, 1);
      expect(result.message, 'something went wrong');
      expect(result.statusCode, 400);
    });

    test('string error', () async {
      APIController.client = MockClient((request) async {
        final response = {"error": "something went wrong"};
        return http.Response(json.encode(response), 400);
      });

      final result = await APIController.addUpdateTransaction(transactionDetails, 1);
      expect(result.message, 'error: something went wrong');
      expect(result.statusCode, 400);
    });
  });
}

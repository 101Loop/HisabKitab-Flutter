import 'package:hisabkitab/src/models/password_response.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/models/user.dart';
import 'package:hisabkitab/src/models/user_account.dart' as userAccount;
import 'package:hisabkitab/src/models/user_profile.dart';
import 'package:test/test.dart';

void main() {
  test('user model test', () {
    var userMap = {
      'username': 'dipanshu',
      'password': 'pass',
      'data': {'token': 'asd2q34'},
      'error': null,
      'statusCode': 200
    };

    User user = User(
      username: 'dipanshu',
      password: 'pass',
      data: Data(token: 'asd2q34'),
      statusCode: 200,
    );

    expect(user, User.fromJson(userMap));
  });

  group('all models test', () {
    test('password response test', () {
      var passwordMap = {'data': 'asdfasdf', 'statusCode': 200};

      PasswordResponse password = PasswordResponse(
        data: 'asdfasdf',
        statusCode: 200,
      );

      expect(password, PasswordResponse.fromJson(passwordMap));
    });

    test('transaction model test', () {
      var map = {
        'id': 1,
        'mode': {'id': 0, 'mode': '1'},
        'contact': {'id': 1, 'name': 'salary', 'email': '123@gmail.com', 'mobile': '1234567890'},
        'transaction_date': '25052020',
        'create_date': '25052020',
        'update_date': '25052020',
        'category': 'C',
        'amount': 500,
        'comments': '500',
      };

      TransactionDetails transactionDetails = TransactionDetails(
        id: 1,
        mode: Mode(id: 0, mode: '1'),
        contact: Contact(id: 1, name: 'salary', email: '123@gmail.com', mobile: '1234567890'),
        transactionDate: '25052020',
        createDate: '25052020',
        updateDate: '25052020',
        category: 'C',
        amount: 500,
        comments: '500',
        message: null,
        statusCode: 200,
      );

      expect(transactionDetails, TransactionDetails.fromJson(map));
    });

    test('user model test', () {
      var userMap = {
        'username': 'dipanshu',
        'password': 'pass',
        'data': {'token': 'asd2q34'},
        'error': null,
        'statusCode': 200
      };

      User user = User(
        username: 'dipanshu',
        password: 'pass',
        data: Data(token: 'asd2q34'),
        statusCode: 200,
      );

      expect(user, User.fromJson(userMap));
    });

    test('user data model test', () {
      var userMap = {
        'data': {'name': 'name', 'usernmae': 'user', 'email': 'user@gmail.com', 'mobile': '32165496780', 'password': 'pass'},
      };

      userAccount.UserAccount user = userAccount.UserAccount(
        data: userAccount.Data(name: 'name', username: 'user', email: 'user@gmail.com', mobile: '32165496780', password: 'pass'),
        statusCode: 200,
        error: null,
      );

      expect(user, userAccount.UserAccount.fromJson(userMap));
    });

    test('user profile model test', () {
      var userMap = {
        'id': 1,
        'name': 'dipanshu',
        'email': 'email@gmail.com',
        'mobile': '32165496780',
      };

      UserProfile user = UserProfile(
        id: 1,
        name: 'dipanshu',
        email: 'email@gmail.com',
        mobile: '32165496780',
        statusCode: 200,
        error: null
      );

      expect(user, UserProfile.fromJson(userMap));
    });
  });
}

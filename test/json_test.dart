import 'package:hisabkitab/src/models/paginated_response.dart';
import 'package:hisabkitab/src/models/password_response.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/models/user.dart';
import 'package:hisabkitab/src/models/user_account.dart' as userAccount;
import 'package:hisabkitab/src/models/user_profile.dart';
import 'package:test/test.dart';

void main() {
  group('all models test', () {
    test('paginated response tests', () {
      var transactionMap = {
        'id': 1,
        'amount': 10,
        'mode': {'id': 1, 'mode': '3'},
        'contact': {'id': 1, 'mobile': '123', 'email': 'email@gmail.com', 'name': 'admin'},
        'category': 'C',
        'transaction_date': '20200526',
        'create_date': '20200526',
        'update_date': '20200526',
        'message': null,
        'comments': null,
      };

      var paginatedMap = {
        'count': 10,
        'results': [transactionMap],
        'total_amount': 123,
      };

      PaginatedResponse paginatedResponse = PaginatedResponse(
        count: 10,
        results: [transactionMap],
        totalAmount: 123,
        statusCode: 200,
      );

      var actual = PaginatedResponse.fromJson(paginatedMap);
      expect(paginatedResponse, actual);
    });

    test('password response test', () {
      var passwordMap = {'data': 'asdfasdf', 'statusCode': 200};

      PasswordResponse password = PasswordResponse(
        data: 'asdfasdf',
        statusCode: 200,
      );

      expect(password, PasswordResponse.fromJson(passwordMap));
    });

    group('transaction model test', () {
      var modeObj = Mode(id: 0, mode: '1');
      var contactObj = Contact(id: 1, name: 'salary', email: '123@gmail.com', mobile: '1234567890');

      var transactionMap = {
        'mode': modeObj,
        'contact': contactObj,
        'category': 'C',
        'amount': 500,
        'comments': '500',
        'transaction_date': '25052020',
      };

      var transactionJson = {
        'id': 1,
        'mode': {'id': 0, 'mode': '1'},
        'contact': {'id': 1, 'name': 'salary', 'email': '123@gmail.com', 'mobile': '1234567890'},
        'category': 'C',
        'amount': 500,
        'comments': '500',
        'transaction_date': '25052020',
        'create_date': '25052020',
        'update_date': '25052020',
      };

      TransactionDetails transactionDetails = TransactionDetails(
        id: 1,
        mode: modeObj,
        contact: contactObj,
        transactionDate: '25052020',
        createDate: '25052020',
        updateDate: '25052020',
        category: 'C',
        amount: 500,
        comments: '500',
        message: null,
        statusCode: 200,
      );

      test('transaction map to object test', () {
        expect(transactionDetails, TransactionDetails.fromJson(transactionJson));
      });

      test('transaction object to map test', () {
        expect(transactionMap, transactionDetails.toMap());
      });
    });

    group('user model test', () {
      var userMap = {
        'username': 'dipanshu',
        'password': 'pass',
      };

      var userJson = {
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

      test('user map to object', () {
        expect(user, User.fromJson(userJson));
      });

      test('user object to map', () {
        expect(userMap, user.toMap());
      });
    });

    group('user data model test', () {
      var dataMap = {
        'name': 'name',
        'username': 'user',
        'email': 'user@gmail.com',
        'mobile': '32165496780',
        'password': 'pass',
      };

      var data = userAccount.Data(
        name: 'name',
        username: 'user',
        email: 'user@gmail.com',
        mobile: '32165496780',
        password: 'pass',
      );

      var userMap = {'data': dataMap, 'error': null};

      userAccount.UserAccount user = userAccount.UserAccount(
        data: data,
        statusCode: 200,
        error: null,
      );

      test('user model map to object', () {
        expect(user, userAccount.UserAccount.fromJson(userMap));
      });

      test('user model map to object', () {
        expect(dataMap, data.toMap());
      });
    });

    group('user profile model test', () {
      var userMap = {
        'name': 'dipanshu',
        'email': 'email@gmail.com',
        'mobile': '32165496780',
      };

      var userJson = {
        'id': 1,
        'name': 'dipanshu',
        'email': 'email@gmail.com',
        'mobile': '32165496780',
        'error': null,
      };

      UserProfile user = UserProfile(
        id: 1,
        name: 'dipanshu',
        email: 'email@gmail.com',
        mobile: '32165496780',
        statusCode: 200,
        error: null,
      );

      test('user profile map to object test', () {
        expect(user, UserProfile.fromJson(userJson));
      });

      test('user profile map to object test', () {
        expect(userMap, user.toMap());
      });
    });
  });
}

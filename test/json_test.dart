import 'package:hisabkitab/src/models/user.dart';
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
}

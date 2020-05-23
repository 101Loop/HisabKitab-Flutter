import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("flutter app test", () {
    const Duration TIMEOUT_MEDIUM = Duration(seconds: 5);
    const Duration TIMEOUT_SMALL = Duration(seconds: 2);
    const Duration TIMEOUT_VERY_SMALL = Duration(milliseconds: 500);

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    test("logging in", () async {
      await driver.waitFor(find.byValueKey('loginButton'), timeout: TIMEOUT_MEDIUM);
      await driver.tap(find.byValueKey('loginButton'), timeout: TIMEOUT_MEDIUM);
      await driver.waitFor(find.byValueKey('loginBtn'), timeout: TIMEOUT_MEDIUM);

      await driver.tap(find.byValueKey('usernameField'));
      await driver.enterText('rejithomasm@gmail.com', timeout: TIMEOUT_SMALL);

      await driver.tap(find.byValueKey('passwordField'));
      await driver.enterText('Stephin@123', timeout: TIMEOUT_SMALL);

      await driver.tap(find.byValueKey('loginBtn'), timeout: TIMEOUT_MEDIUM);
      await driver.waitFor(find.byValueKey('bottomNavBar'), timeout: TIMEOUT_MEDIUM);
      expect(await driver.getText(find.byValueKey('transactionType')), 'All Transaction');
    });

    test('transaction list scroll test', () async {
       await driver.scroll(find.byValueKey('transactionListview'), 0, -500, TIMEOUT_VERY_SMALL);
       await driver.scroll(find.byValueKey('transactionListview'), 0, 500, TIMEOUT_VERY_SMALL);
       await driver.scroll(find.byValueKey('transactionListview'), 0, -500, TIMEOUT_VERY_SMALL);
    });
  });
}

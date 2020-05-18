import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("flutter app test", () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    test("logging in", () async {
      const Duration TIMEOUT_MEDIUM = Duration(seconds: 5);
      const Duration TIMEOUT_SMALL = Duration(seconds: 2);

      await driver.waitFor(find.byValueKey('loginButton'), timeout: TIMEOUT_MEDIUM);
      await driver.tap(find.byValueKey('loginButton'), timeout: TIMEOUT_MEDIUM);
      await driver.waitFor(find.byValueKey('loginBtn'), timeout: TIMEOUT_MEDIUM);

      await driver.tap(find.byValueKey('usernameField'));
      await driver.enterText('rejithomasm@gmail.com', timeout: TIMEOUT_SMALL);

      await driver.tap(find.byValueKey('passwordField'));
      await driver.enterText('Stephin@123', timeout: TIMEOUT_SMALL);

      await driver.tap(find.byValueKey('loginBtn'), timeout: TIMEOUT_MEDIUM);
      await driver.waitFor(find.byValueKey('bottomNavBar'), timeout: TIMEOUT_MEDIUM);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:hisabkitab/src/mixins/validator.dart';

void main() {
  test('tests nullable or empty-able double', () {
    var result = ValidationMixin().validateNullableDoubleValue(null);
    expect(result, null);
  });

  test('tests nullable or empty-able mobile', () {
    var result = ValidationMixin().validateNullableMobile('9999999999');
    expect(result, null);
  });

  test('tests nullable or empty-able email', () {
    var result = ValidationMixin().validateNullableEmail('null@gm.com');
    expect(result, null);
  });
}

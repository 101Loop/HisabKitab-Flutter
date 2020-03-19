import 'package:flutter_test/flutter_test.dart';
import 'package:hisabkitab/src/mixins/validator.dart';

void main(){
  test('tests nullable or empty-able double', (){
    var result = ValidationMixin().validateNullableDoubleValue(null);
    expect(result, null);
  });
}
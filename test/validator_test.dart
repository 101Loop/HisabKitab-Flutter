import 'package:hisabkitab/src/mixins/validator.dart';
import 'package:test/test.dart';

void main() {
  const String EMOJI_TEXT = '😋😋😋😋😋😋😋😋😋😋😋😋😋😋';

  group('full validation test', () {
    group('password validation test', () {
      test('null password test', () {
        String result = ValidationMixin.validatePassword(null);
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('empty password test', () {
        String result = ValidationMixin.validatePassword('');
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('emoji password test', () {
        String result = ValidationMixin.validatePassword(EMOJI_TEXT);
        expect(result, ValidationMixin.IS_EMOJI);
      });

      test('just alphabets test', () {
        String result = ValidationMixin.validatePassword('asdfasdf');
        expect(result, ValidationMixin.INVALID_PASSWORD);
      });

      test('just numbers test', () {
        String result = ValidationMixin.validatePassword('123456789');
        expect(result, ValidationMixin.INVALID_PASSWORD);
      });

      test('just special character test', () {
        String result = ValidationMixin.validatePassword('!@#\\\$%^&*()_+|<>?:"{}[]');
        expect(result, ValidationMixin.INVALID_PASSWORD);
      });

      test('alphanumeric test', () {
        String result = ValidationMixin.validatePassword('asdf123456');
        expect(result, ValidationMixin.INVALID_PASSWORD);
      });

      test('alphanumeric with special characters test', () {
        String result = ValidationMixin.validatePassword('asd@f123456');
        expect(result, ValidationMixin.INVALID_PASSWORD);
      });

      test('small password test', () {
        String result = ValidationMixin.validatePassword('asd@f');
        expect(result, ValidationMixin.INVALID_PASSWORD);
      });

      test('extremely large password test, jibberish input', () {
        String result = ValidationMixin.validatePassword('sadlfasdfjl;aksjf;ljsdl;fjasldfj;j@1231231');
        expect(result, ValidationMixin.INVALID_PASSWORD);
      });

      test('normal user password test', () {
        String result = ValidationMixin.validatePassword('password123');
        expect(result, ValidationMixin.INVALID_PASSWORD);
      });

      test('intermediate user password test', () {
        String result = ValidationMixin.validatePassword('password@123');
        expect(result, ValidationMixin.INVALID_PASSWORD);
      });

      test('advanced user password test', () {
        String result = ValidationMixin.validatePassword('Password@123@123@');
        expect(result, null);
      });

      test('password with randomly ordered password requirements', () {
        String result = ValidationMixin.validatePassword('@123@Password123@');
        expect(result, null);
      });
    });

    group("email validation test", () {
      test('null email test', () {
        String result = ValidationMixin.validateEmail(null);
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('empty email test', () {
        String result = ValidationMixin.validateEmail('');
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('emoji email test', () {
        String result = ValidationMixin.validateEmail(EMOJI_TEXT);
        expect(result, ValidationMixin.IS_EMOJI);
      });

      test('special character email test', () {
        String result = ValidationMixin.validateEmail('!#\$@gmail.com');
        expect(result, null);
      });

      test('non-email test', () {
        String result = ValidationMixin.validateEmail('sdfjl;j');
        expect(result, ValidationMixin.INVALID_EMAIL);
      });

      test('valid email test', () {
        String result = ValidationMixin.validateEmail('abc@gmail.com');
        expect(result, null);
      });

      test('without domain email test', () {
        String result = ValidationMixin.validateEmail('abc@');
        expect(result, ValidationMixin.INVALID_EMAIL);
      });

      test('just domain name', () {
        String result = ValidationMixin.validateEmail('gmail.com');
        expect(result, ValidationMixin.INVALID_EMAIL);
      });
    });

    group('non-empty or non-null field validation test', () {
      test('null value test', () {
        String result = ValidationMixin.validateField(null);
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('empty value test', () {
        String result = ValidationMixin.validateField('');
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('non-empty random value test', () {
        String result = ValidationMixin.validateField('asdfadsfwefasdfawerfwfsadfaf');
        expect(result, null);
      });
    });

    group('OTP validation test', () {
      test('null OTP test', () {
        String result = ValidationMixin.validateOTP(null);
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('empty OTP test', () {
        String result = ValidationMixin.validateOTP('');
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('emoji OTP test', () {
        String result = ValidationMixin.validateOTP(EMOJI_TEXT);
        expect(result, ValidationMixin.IS_EMOJI);
      });

      test('len less than 7', () {
        String result = ValidationMixin.validateOTP('123456');
        expect(result, ValidationMixin.INVALID_OTP);
      });

      test('len equal to 7', () {
        String result = ValidationMixin.validateOTP('1234567');
        expect(result, null);
      });

      test('len more than 7', () {
        String result = ValidationMixin.validateOTP('123456457');
        expect(result, null);
      });

      test('chars less than 7', () {
        String result = ValidationMixin.validateOTP('a');
        expect(result, ValidationMixin.INVALID_OTP);
      });

      test('chars equal to 7', () {
        String result = ValidationMixin.validateOTP('asdfasd');
        expect(result, ValidationMixin.INVALID_OTP);
      });

      test('chars more than 7', () {
        String result = ValidationMixin.validateOTP('sdfaasdfa');
        expect(result, ValidationMixin.INVALID_OTP);
      });
    });

    group('mobile validation test', () {
      test('null mobile test', () {
        String result = ValidationMixin.validateMobile(null);
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('empty mobile test', () {
        String result = ValidationMixin.validateMobile('');
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('emoji mobile test', () {
        String result = ValidationMixin.validateMobile(EMOJI_TEXT);
        expect(result, ValidationMixin.IS_EMOJI);
      });

      test('random chars mobile test', () {
        String result = ValidationMixin.validateMobile('lsdjfoawijf');
        expect(result, ValidationMixin.INVALID_MOBILE);
      });

      test('less numbered mobile test', () {
        String result = ValidationMixin.validateMobile('123');
        expect(result, ValidationMixin.INVALID_MOBILE);
      });

      test('more numbered mobile test', () {
        String result = ValidationMixin.validateMobile('1231232545774');
        expect(result, ValidationMixin.INVALID_MOBILE);
      });

      test('valid mobile test', () {
        String result = ValidationMixin.validateMobile('9876543210');
        expect(result, null);
      });

      test('valid mobile, with +91 test', () {
        String result = ValidationMixin.validateMobile('+919876543210');
        expect(result, null);
      });

      test('valid mobile, with +91 test', () {
        String result = ValidationMixin.validateMobile('919876543210');
        expect(result, null);
      });
    });

    group('double value validation test', () {
      test('null value test', () {
        String result = ValidationMixin.validateDoubleValue(null);
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('empty mobile test', () {
        String result = ValidationMixin.validateDoubleValue('');
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('emoji mobile test', () {
        String result = ValidationMixin.validateDoubleValue(EMOJI_TEXT);
        expect(result, ValidationMixin.IS_EMOJI);
      });

      test('value with multiple dots test', () {
        String result = ValidationMixin.validateDoubleValue('123.1.1');
        expect(result, ValidationMixin.INVALID_VALUE);
      });

      test('negative value test', () {
        String result = ValidationMixin.validateDoubleValue('-120');
        expect(result, ValidationMixin.IS_NEGATIVE_VALUE);
      });

      test('large value test', () {
        String result = ValidationMixin.validateDoubleValue('1326523984750923740957230945709234746565.00');
        expect(result, ValidationMixin.IS_LARGE_VALUE);
      });

      test('extra decimal value test', () {
        String result = ValidationMixin.validateDoubleValue('12.0000000000000000001');
        expect(result, null);
      });

      test('string/chars test', () {
        String result = ValidationMixin.validateDoubleValue('helloWorld!');
        expect(result, ValidationMixin.INVALID_VALUE);
      });

      test('int test', () {
        String result = ValidationMixin.validateDoubleValue('15');
        expect(result, null);
      });

      test('valid double test', () {
        String result = ValidationMixin.validateDoubleValue('15.00');
        expect(result, null);
      });
    });

    group('nullable double value validation test, either null or valid double passes the test', () {
      test('null value test', () {
        String result = ValidationMixin.validateNullableDoubleValue(null);
        expect(result, null);
      });

      test('empty mobile test', () {
        String result = ValidationMixin.validateNullableDoubleValue('');
        expect(result, null);
      });

      test('emoji mobile test', () {
        String result = ValidationMixin.validateNullableDoubleValue(EMOJI_TEXT);
        expect(result, ValidationMixin.IS_EMOJI);
      });

      test('value with multiple dots test', () {
        String result = ValidationMixin.validateNullableDoubleValue('123.1.1');
        expect(result, ValidationMixin.INVALID_VALUE);
      });

      test('negative value test', () {
        String result = ValidationMixin.validateNullableDoubleValue('-120');
        expect(result, ValidationMixin.IS_NEGATIVE_VALUE);
      });

      test('large value test', () {
        String result = ValidationMixin.validateNullableDoubleValue('1326523984750923740957230945709234746565.00');
        expect(result, ValidationMixin.IS_LARGE_VALUE);
      });

      test('extra decimal value test', () {
        String result = ValidationMixin.validateNullableDoubleValue('12.0000000000000000001');
        expect(result, null);
      });

      test('string/chars test', () {
        String result = ValidationMixin.validateNullableDoubleValue('helloWorld!');
        expect(result, ValidationMixin.INVALID_VALUE);
      });

      test('int test', () {
        String result = ValidationMixin.validateNullableDoubleValue('15');
        expect(result, null);
      });

      test('valid double test', () {
        String result = ValidationMixin.validateNullableDoubleValue('15.00');
        expect(result, null);
      });
    });

    group('non-emoji input validation', () {
      test('null value test', () {
        String result = ValidationMixin.validateNonEmoji(null);
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('empty value test', () {
        String result = ValidationMixin.validateNonEmoji('');
        expect(result, ValidationMixin.IS_EMPTY);
      });

      test('emoji test', () {
        String result = ValidationMixin.validateNonEmoji(EMOJI_TEXT);
        expect(result, ValidationMixin.IS_EMOJI);
      });

      test('char value test', () {
        String result = ValidationMixin.validateNonEmoji('EMOJI_TEXT');
        expect(result, null);
      });

      test('int value test', () {
        String result = ValidationMixin.validateNonEmoji('123');
        expect(result, null);
      });

      test('double value test', () {
        String result = ValidationMixin.validateNonEmoji('123.00');
        expect(result, null);
      });

      test('alphanumeric value test', () {
        String result = ValidationMixin.validateNonEmoji('EMOJI_TEXT');
        expect(result, null);
      });
    });
  });
}

import 'package:hisabkitab/main.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;

class Utility {
  static String _token;

  static String get token => _token;

  static void saveToken(String token){
    prefs.remove(Constants.TOKEN);
    prefs.setString(Constants.TOKEN, token);

    _token = token;
  }

  static void deleteToken(){
    prefs.remove(Constants.TOKEN);
  }
}
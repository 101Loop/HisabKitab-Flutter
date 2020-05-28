import 'package:hisabkitab/main.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  /// Uniquely identifies the user, used for communicating with the server
  static String _token;

  /// Gets the [token]
  static String get token => _token;

  /// Saves [token] in the shared prefs
  static void saveToken(String token){
    prefs.remove(Constants.TOKEN);
    prefs.setString(Constants.TOKEN, token);

    _token = token;
  }

  /// Deletes token from the shared prefs
  static void deleteToken(){
    prefs.remove(Constants.TOKEN);
  }

  /// Instantiates shared prefs instance
  static void initialize() async {
    prefs = await SharedPreferences.getInstance();
  }
}
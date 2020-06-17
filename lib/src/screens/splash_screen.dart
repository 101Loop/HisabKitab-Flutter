import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hisabkitab/main.dart';
import 'package:hisabkitab/src/screens/account_screen/account.dart';
import 'package:hisabkitab/src/screens/account_screen/welcome_screen.dart';
import 'package:hisabkitab/src/screens/main_screen.dart';
import 'package:hisabkitab/utils/app_localizations.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:hisabkitab/utils/shared_prefs.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Device's height and width
  double deviceHeight;
  double deviceWidth;
  String token;

  /// Instance of [AppLocalizations], to get the translated word
  AppLocalizations appLocalizations;

  /// List of the available languages
  ///
  /// See lang/langs.json
  List<Map<String, String>> availableLangList = List();

  /// Currently selected language
  String _currentSelectedLang = '';

  @override
  void initState() {
    super.initState();

    if (prefs == null) SharedPrefs.initialize();

    /// Gets and sets the token
    token = prefs.getString(Constants.TOKEN);
    SharedPrefs.saveToken(token);

    /// Gets the languages from the lang/langs.json
    _getAvailableLangs();

    /// Sets the current language, based on the user's preference
    _currentSelectedLang = prefs.getString('languageCode');

    /// Navigates to either welcome screen or main screen
    ///
    /// if the user is already logged in navigate to main screen otherwise welcome screen
    Future.delayed(Duration(seconds: 3), () async {
      loadLangOption();
    });
  }

  /// Handles the back press
  Future<bool> _onBackPressed() async {
    /// Exits the app

    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: deviceWidth,
          height: deviceHeight,
          color: Constants.primaryColor,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                bottom: deviceHeight * 0.41,
                child: Center(
                  child: Text(
                    'Hisab Kitab',
                    style: TextStyle(
                      fontFamily: 'YeonSung',
                      fontSize: 33.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: deviceHeight * 0.5,
                child: Center(
                  child: Container(
                    width: 135,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loadLangOption() {
    String language = prefs?.getString('languageCode');
    print(language);
    if (language != null && language.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => token == null ? WelcomeScreen() : MainScreen(),
        ),
      );
    } else {
      _showLanguageChangeDialog();
    }
  }

  /// Displays dialog to change language
  Future<bool> _showLanguageChangeDialog() {
    return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: _onBackPressed,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: Text('Select Language'),
                contentPadding: const EdgeInsets.all(5.0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      width: 300,
                      height: 150,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: availableLangList.length,
                        itemBuilder: _langOptionItemBuilder,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () => SystemNavigator.pop(),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  /// Gets available languages from langs.json file
  void _getAvailableLangs() async {
    availableLangList.clear();
    var langJsonString = await rootBundle.loadString('lang/langs.json');
    List langList = json.decode(langJsonString);
    langList.forEach((item) {
      Map<String, String> map = (item as Map).map((key, value) =>
          MapEntry(key, value != null ? value.toString() : null));
      availableLangList.add(map);
    });
  }

  /// Item widget builder, creates a LanguageOption widget
  Widget _langOptionItemBuilder(BuildContext context, int index) {
    String language = availableLangList[index]['language'];
    String languageCode = availableLangList[index]['languageCode'];

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _currentSelectedLang = languageCode;
            prefs.setString('languageCode', languageCode);
            appLocalizations.load();
            setState(() {});
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    token == null ? WelcomeScreen() : MainScreen(),
              ),
            );
          },
          child: LanguageOption(
              language: language,
              isSelected: languageCode == _currentSelectedLang),
        ),
        index != availableLangList.length - 1 ? Divider() : Container()
      ],
    );
  }
}

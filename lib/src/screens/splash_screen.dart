import 'package:flutter/material.dart';
import 'package:hisabkitab/main.dart';
import 'package:hisabkitab/src/screens/account_screen/welcome_screen.dart';
import 'package:hisabkitab/src/screens/main_screen.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:hisabkitab/utils/utility.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Device's height and width
  double deviceHeight;
  double deviceWidth;

  @override
  void initState() {
    /// Gets and sets the token
    String token = prefs.getString(Constants.TOKEN);
    Utility.saveToken(token);

    /// Navigates to either welcome screen or main screen
    ///
    /// if the user is already logged in navigate to main screen otherwise welcome screen
    Future.delayed(Duration(seconds: 3), () async {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => token == null ? WelcomeScreen() : MainScreen(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
}

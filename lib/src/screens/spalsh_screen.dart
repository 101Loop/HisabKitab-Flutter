import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/screens/account_screen/welcome_screen.dart';
import 'package:hisabkitab/utils/const.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double deviceHeight;
  double deviceWidth;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(),
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
          color: primaryColor,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                bottom: deviceHeight * 0.5,
                child: Center(
                  child: Text(
                    'Hisab Kitab',
                    style: GoogleFonts.yeonSung(
                      fontSize: 30.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: deviceHeight * 0.44,
                child: Center(
                  child: Text(
                    'हिसाब किताब',
                    style: GoogleFonts.cambay(
                      fontSize: 30.0,
                      color: Colors.black,
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

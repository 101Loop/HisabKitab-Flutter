import 'package:flutter/material.dart';
import 'package:hisabkitab/src/screens/account_screen/login_screen.dart';
import 'package:hisabkitab/src/screens/account_screen/sign_up_screen.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double deviceHeight;
  double deviceWidth;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Hero(
                  tag: 'Logo',
                  child: Container(
                    height: 120.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              AssetImage('assets/images/hisab_kitab_logo.png')),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Center(
                  child: HeaderWidget(
                    headerText: 'Hisab Kitab',
                    maxFontSize: 40,
                    minFontSize: 35,
                    textColor: Colors.black,
                  ),
                ),
                SizedBox(height: 40.0),
                Center(
                  child: HeaderWidget(
                    headerText: 'Welcome to Hisab Kitab!',
                    maxFontSize: 30,
                    minFontSize: 25,
                    textColor: Colors.black,
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: HeaderWidget(
                    headerText: 'Make It Easy',
                    maxFontSize: 25,
                    minFontSize: 20,
                    textColor: Colors.black54,
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  padding: EdgeInsets.all(20.0),
                  width: deviceWidth,
                  decoration: BoxDecoration(
                    color: profileBG,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: deviceWidth * 0.75,
                        height: 50.0,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: HeaderWidget(
                            headerText: 'LOGIN',
                            maxFontSize: 20,
                            minFontSize: 18,
                            textColor: Colors.white,
                          ),
                          color: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        width: deviceWidth * 0.75,
                        height: 50.0,
                        child: OutlineButton(
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                          child: HeaderWidget(
                            headerText: 'SIGN UP',
                            maxFontSize: 20,
                            minFontSize: 18,
                            textColor: primaryColor,
                          ),
                          color: primaryColor,
                          splashColor: lightGreen.withRed(210),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

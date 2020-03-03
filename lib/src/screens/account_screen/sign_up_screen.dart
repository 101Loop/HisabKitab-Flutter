import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/screens/account_screen/login_screen.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: HeaderWidget(
                    headerText: 'Sign up',
                    maxFontSize: 30,
                    minFontSize: 28,
                    textColor: Colors.black,
                  ),
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
                SizedBox(height: 20.0),
                Container(
                  width: deviceWidth,
                  decoration: BoxDecoration(
                    color: profileBG,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 30.0, left: 20.0),
                        child: HeaderWidget(
                          headerText: "Let's get started",
                          textColor: Colors.black54,
                          maxFontSize: 18,
                          minFontSize: 16,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          cursorColor: primaryColor,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            fillColor: Colors.white,
                            hintText: 'Name',
                            alignLabelWithHint: true,
                            hintStyle: GoogleFonts.nunito(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          cursorColor: primaryColor,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            fillColor: Colors.white,
                            hintText: 'Email',
                            alignLabelWithHint: true,
                            hintStyle: GoogleFonts.nunito(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          cursorColor: primaryColor,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            fillColor: Colors.white,
                            hintText: 'Mobile',
                            alignLabelWithHint: true,
                            hintStyle: GoogleFonts.nunito(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          obscureText: true,
                          cursorColor: primaryColor,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            fillColor: Colors.white,
                            hintText: 'Password',
                            alignLabelWithHint: true,
                            hintStyle: GoogleFonts.nunito(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          obscureText: true,
                          cursorColor: primaryColor,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            fillColor: Colors.white,
                            hintText: 'Confirm Password',
                            alignLabelWithHint: true,
                            hintStyle: GoogleFonts.nunito(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: deviceWidth * 0.75,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {},
                    child: HeaderWidget(
                      headerText: 'SIGN UP',
                      maxFontSize: 20,
                      minFontSize: 18,
                      textColor: Colors.white,
                    ),
                    color: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: buttonColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Text(
                    'Already have account?',
                    style: GoogleFonts.nunito(
                      fontSize: 16.0,
                      wordSpacing: 1,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Container(
                  width: deviceWidth * 0.75,
                  height: 50.0,
                  child: OutlineButton(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: HeaderWidget(
                      headerText: 'LOGIN',
                      maxFontSize: 20,
                      minFontSize: 18,
                      textColor: Colors.black54,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

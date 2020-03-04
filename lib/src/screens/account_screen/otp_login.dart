import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/account_screen/sign_up_screen.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:provider/provider.dart';

class OTPLoginScreen extends StatefulWidget {
  @override
  _OTPLoginScreenState createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> {
  double deviceHeight;
  double deviceWidth;
  AppState provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppState>(context);
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
                    headerText: 'LOGIN WITH OTP',
                    maxFontSize: 30,
                    minFontSize: 25,
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
                          headerText: 'Sign in to continue',
                          textColor: Colors.black54,
                          maxFontSize: 18,
                          minFontSize: 15,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          cursorColor: primaryColor,
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            fillColor: Colors.white,
                            hintText: 'Email/Phone',
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
                      provider.getOTPRequested
                          ? Container(
                              margin:
                                  EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                cursorColor: primaryColor,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                  fillColor: Colors.white,
                                  hintText: 'OTP',
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
                            )
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: deviceWidth * 0.75,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      provider.setOTPRequested(true, willNotify: true);
                    },
                    child: HeaderWidget(
                      headerText:
                          !provider.getOTPRequested ? 'GET OTP' : 'LOGIN',
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
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: HeaderWidget(
                      headerText: 'SIGN UP',
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

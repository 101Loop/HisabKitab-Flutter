import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/api_controller/signUp_api_controller.dart';
import 'package:hisabkitab/src/mixins/validator.dart';
import 'package:hisabkitab/src/models/user_account.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/account_screen/login_screen.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with ValidationMixin {
  double deviceHeight;
  double deviceWidth;
  AppState provider;

  final signUpFormKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _name = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _mobile = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final TextEditingController _confirmPass = TextEditingController();

  Future<UserAccount> signUpResponse;

  @override
  void initState() {
    super.initState();
    var _provider = Provider.of<AppState>(context, listen: false);
    _provider.initialState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppState>(context);
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: profileBG,
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
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
                        height: 10.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      width: deviceWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                          Form(
                            key: signUpFormKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    cursorColor: primaryColor,
                                    textAlign: TextAlign.left,
                                    autovalidate: provider.autoValidate,
                                    validator: validateField,
                                    controller: _name,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                                    autovalidate: provider.autoValidate,
                                    validator: validateEmail,
                                    controller: _email,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                                    autovalidate: provider.autoValidate,
                                    validator: validateMobile,
                                    controller: _mobile,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                                    obscureText: provider.isHideText,
                                    cursorColor: primaryColor,
                                    textAlign: TextAlign.left,
                                    autovalidate: provider.autoValidate,
                                    validator: validatePassword,
                                    controller: _password,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                                      suffixIcon: IconButton(
                                        icon: provider.isHideText
                                            ? Icon(
                                                Icons.visibility_off,
                                                color: Colors.grey.shade400,
                                              )
                                            : Icon(
                                                Icons.visibility,
                                                color: Colors.grey.shade400,
                                              ),
                                        onPressed: () {
                                          provider.setHideText(!provider.isHideText);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    obscureText: provider.isHideText1,
                                    cursorColor: primaryColor,
                                    textAlign: TextAlign.left,
                                    autovalidate: provider.autoValidate,
                                    validator: (value) {
                                      if (value != _password.text) {
                                        return 'Password does\'t match';
                                      }
                                      return null;
                                    },
                                    controller: _confirmPass,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                                      suffixIcon: IconButton(
                                        icon: provider.isHideText1
                                            ? Icon(
                                                Icons.visibility_off,
                                                color: Colors.grey.shade400,
                                              )
                                            : Icon(
                                                Icons.visibility,
                                                color: Colors.grey.shade400,
                                              ),
                                        onPressed: () {
                                          provider.setHideText1(!provider.isHideText1);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                        onPressed: onSignUpClicked,
                        child: HeaderWidget(
                          headerText: 'SIGN UP',
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
                          FocusScope.of(context).unfocus();
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
                          textColor: primaryColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        splashColor: lightGreen.withRed(210),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
              provider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  void onSignUpClicked() {
    FocusScope.of(context).unfocus();
    provider.setAutoValidate(true);
    UserAccount userAccount = UserAccount(
      data: Data(
        name: _name.text,
        username: _name.text + _mobile.text,
        email: _email.text,
        mobile: _mobile.text,
        password: _password.text,
      ),
    );
    final FormState form = signUpFormKey.currentState;
    if (form.validate()) {
      provider.setLoading(true);
      form.save();
      signUpResponse = SignUpAPIController.registerUser(userAccount);
      signUpResponse.then((response) {
        provider.setLoading(false);
        if (response.error != null) {
          showSnackBar(response.error);
        } else if (response.data.email != null && response.data.mobile != null) {
          showSnackBar('SignUp Sucessfully');
          Future.delayed(
            Duration(seconds: 2),
            navigateToLogin,
          );
        }
      });
    }
  }

  showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        shape: RoundedRectangleBorder(),
      ),
    );
  }

  navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }),
    );
  }
}

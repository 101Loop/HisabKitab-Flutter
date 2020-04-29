import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/api_controller/login_api_controller.dart';
import 'package:hisabkitab/src/mixins/validator.dart';
import 'package:hisabkitab/src/models/user.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/account_screen/otp_login.dart';
import 'package:hisabkitab/src/screens/account_screen/sign_up_screen.dart';
import 'package:hisabkitab/src/screens/dashboard.dart';
import 'package:hisabkitab/src/screens/main_screen.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  double deviceHeight;
  double deviceWidth;
  AppState provider;
  Future<User> _futureUser;

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                      margin: EdgeInsets.only(top: 30.0, bottom: 20.0),
                      child: HeaderWidget(
                        headerText: 'LOGIN',
                        maxFontSize: 30,
                        minFontSize: 25,
                        textColor: Colors.black,
                      ),
                    ),
                    Hero(
                      tag: 'Logo',
                      child: Container(
                        height: 50.0,
                      ),
                    ),
                    SizedBox(height: 20.0),
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
                              headerText: 'Sign in to continue',
                              textColor: Colors.black54,
                              maxFontSize: 18,
                              minFontSize: 15,
                            ),
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(15.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    autovalidate: provider.autoValidate,
                                    controller: usernameController,
                                    validator: validateField,
                                    cursorColor: primaryColor,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 0.0, 0.0, 0.0),
                                      fillColor: Colors.white,
                                      hintText: 'Email/Phone',
                                      alignLabelWithHint: true,
                                      hintStyle: GoogleFonts.nunito(
                                        color: Colors.grey.shade400,
                                        fontSize: 14,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      15.0, 0.0, 15.0, 15.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    obscureText: provider.isHideText,
                                    cursorColor: primaryColor,
                                    textAlign: TextAlign.left,
                                    controller: passwordController,
                                    autovalidate: provider.autoValidate,
                                    validator: validateField,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 0.0, 0.0, 0.0),
                                      fillColor: Colors.white,
                                      hintText: 'Password',
                                      alignLabelWithHint: true,
                                      hintStyle: GoogleFonts.nunito(
                                        color: Colors.grey.shade400,
                                        fontSize: 14,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                          provider.setHideText(
                                              !provider.isHideText);
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
                        onPressed: () {
                          _onLoginPressed();
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OTPLoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Text(
                          'Forgot Password? Login with OTP.',
                          style: GoogleFonts.nunito(
                            fontSize: 16.0,
                            wordSpacing: 1,
                            color: Colors.black54,
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

  void _onLoginPressed() {
    provider.setAutoValidate(true);
    if (formKey.currentState.validate()) {
      provider.setLoading(true);
      FocusScope.of(context).requestFocus(FocusNode());
      formKey.currentState.save();
      print(usernameController.text);
      print(passwordController.text);
      User user = User(
        username: usernameController.text,
        password: passwordController.text,
      );
      _futureUser = LoginAPIController.login(user);
      _futureUser.then((response) {
        provider.setLoading(false);
        if (response.error != null) {
          showSnackBar(response.error ?? '');
        } else if (response.data.token != null) {
          provider.setCurrentTab(0, willNotify: false);
          provider.setCurrentPage(Dashboard());
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainScreen()),
              (Route<dynamic> route) => false);
        }
      });
    }
  }

  ///method to show SnackBar
  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message ?? ''),
      ),
    );
  }
}

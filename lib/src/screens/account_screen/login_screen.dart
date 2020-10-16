import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/api_controller/api_controller.dart';
import 'package:hisabkitab/src/mixins/validator.dart';
import 'package:hisabkitab/src/models/user.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/account_screen/otp_login.dart';
import 'package:hisabkitab/src/screens/account_screen/sign_up_screen.dart';
import 'package:hisabkitab/src/screens/dashboard.dart';
import 'package:hisabkitab/src/screens/main_screen.dart';
import 'package:hisabkitab/utils/app_localizations.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  /// Device's height and width
  double deviceHeight;
  double deviceWidth;

  /// Holds the state of the app
  AppState provider;

  /// Future instance of [User]
  Future<User> _futureUser;

  /// Global key of form state, used for validating the form
  final formKey = GlobalKey<FormState>();

  /// Global key of Scaffold state, used for showing the [SnackBar]
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Text field controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Instance of [AppLocalizations], used for getting the translated words
  AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
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
                        headerText: appLocalizations.translate('login'),
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
                              headerText: appLocalizations.translate('signInToContinue'),
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
                                    key: ValueKey('usernameField'),
                                    autovalidateMode: provider.autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
                                    controller: usernameController,
                                    validator: (value) {
                                      String result = ValidationMixin.validateField(value);
                                      if (result != null)
                                        return appLocalizations.translate(result);
                                      else
                                        return result;
                                    },
                                    cursorColor: primaryColor,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                      fillColor: Colors.white,
                                      hintText: appLocalizations.translate('emailPhone'),
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
                                    key: ValueKey('passwordField'),
                                    obscureText: provider.isHideText,
                                    cursorColor: primaryColor,
                                    textAlign: TextAlign.left,
                                    controller: passwordController,
                                    autovalidateMode: provider.autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
                                    validator: (value) {
                                      String result = ValidationMixin.validateField(value);
                                      if (result != null)
                                        return appLocalizations.translate(result);
                                      else
                                        return result;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                      fillColor: Colors.white,
                                      hintText: appLocalizations.translate('password'),
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
                        key: ValueKey('loginBtn'),
                        onPressed: () {
                          _onLoginPressed();
                        },
                        child: HeaderWidget(
                          headerText: appLocalizations.translate('login'),
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
                        provider.setLoading(false, willNotify: false);
                        provider.setOTPRequested(false, willNotify: false);
                        provider.setAutoValidate(false, willNotify: false);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OTPLoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Text(
                          appLocalizations.translate('forgotPassLogWithOTP'),
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
                          provider.setLoading(false, willNotify: false);
                          provider.setAutoValidate(false, willNotify: false);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: HeaderWidget(
                          headerText: appLocalizations.translate('signUp'),
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

  /// Handles login press
  ///
  /// Simply validates the input, calls and handles the API, if the input is validated
  void _onLoginPressed() {
    /// Makes the loader to rotate
    provider.setAutoValidate(true);

    /// Checks if the input is valid
    if (formKey.currentState.validate()) {
      /// Makes the loader to stop rotating
      provider.setLoading(true);

      /// Un-focuses the text fields
      FocusScope.of(context).unfocus();

      /// Saves the text fields inputs... internally calls the onSaved() method in [TextFormField]
      formKey.currentState.save();

      /// Creates an instance of [User]
      User user = User(
        username: usernameController.text,
        password: passwordController.text,
      );

      /// Makes an API call
      _futureUser = APIController.login(user);
      _futureUser.then((response) {
        /// Makes the loader to stop rotating
        provider.setLoading(false);

        /// Handles the response
        if (response.error != null) {
          String error = response.error;
          if (response.statusCode == 0) error = appLocalizations.translate(error);

          showSnackBar(error ?? '');
        } else if (response.data.token != null) {
          /// Sets the current tab to [Dashboard] and navigates to main screen
          provider.setCurrentTab(0, willNotify: false);
          provider.setCurrentPage(Dashboard(), willNotify: false);
          provider.setNeedsUpdate(true, willNotify: false);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainScreen()), (Route<dynamic> route) => false);
        }
      });
    }
  }

  /// Displays [SnackBar]
  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message ?? ''),
      ),
    );
  }
}

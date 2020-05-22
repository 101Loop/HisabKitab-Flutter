import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/api_controller/api_controller.dart';
import 'package:hisabkitab/src/mixins/validator.dart';
import 'package:hisabkitab/src/models/password_response.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/account_screen/sign_up_screen.dart';
import 'package:hisabkitab/src/screens/main_screen.dart';
import 'package:hisabkitab/utils/app_localizations.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:hisabkitab/utils/utility.dart';
import 'package:provider/provider.dart';

class OTPLoginScreen extends StatefulWidget {
  @override
  _OTPLoginScreenState createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> with ValidationMixin {
  /// Device's height and width
  double deviceHeight;
  double deviceWidth;

  /// Holds the app state
  AppState provider;

  /// Global key of form state, used for validating the input
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Text field controllers
  final TextEditingController _email = TextEditingController();
  final TextEditingController _otp = TextEditingController();

  /// Holds the OTP
  int otp;

  /// Global key of Scaffold state, used for showing the [SnackBar]
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Instance of [AppLocalizations], gets the translated word
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
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 30.0, bottom: 20.0),
                      child: HeaderWidget(
                        headerText: appLocalizations.translate('logWithOTP'),
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
                        color: profileBG,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Form(
                        autovalidate: provider.autoValidate,
                        key: _formKey,
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
                            Container(
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _email,
                                cursorColor: primaryColor,
                                textAlign: TextAlign.left,
                                validator: (value) {
                                  String result = ValidationMixin.validateEmail(value);
                                  if (result != null)
                                    return appLocalizations.translate(result);
                                  else
                                    return result;
                                },
                                autovalidate: provider.autoValidate,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                  fillColor: Colors.white,
                                  hintText: appLocalizations.translate('email'),
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
                                    margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _otp,
                                      cursorColor: primaryColor,
                                      textAlign: TextAlign.left,
                                      validator: (value) {
                                        String result = ValidationMixin.validateOTP(value);
                                        if (result != null)
                                          return appLocalizations.translate(result);
                                        else
                                          return result;
                                      },
                                      autovalidate: provider.autoValidate,
                                      maxLength: 7,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: deviceWidth * 0.75,
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: onButtonPressed,
                        child: HeaderWidget(
                          headerText: !provider.getOTPRequested ? appLocalizations.translate('getOTP') : appLocalizations.translate('login'),
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
            ),
            provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  /// Handles the button pressed
  ///
  /// Validates the input and gets the OTP
  void onButtonPressed() {
    /// Un-focuses the text field
    FocusScope.of(context).unfocus();

    /// Sets the text fields to auto validate, on each value change
    provider.setAutoValidate(true);

    /// Checks if the input is valid
    if (_formKey.currentState.validate()) {
      /// Saves the input data... internally calls onSaved() method in [TextFormField]
      _formKey.currentState.save();

      /// Makes the loader to start rotating
      provider.setLoading(true);

      /// Handles the OTP login
      handleOTPLogin();
    }
  }

  /// Handles the OTP login
  ///
  /// if the OTP is null, gets the OTP otherwise logins the user using the OTP itself
  void handleOTPLogin() {
    /// if the OTP's already requested set the OTP from the input field, otherwise set it null
    (provider.getOTPRequested) ? otp = int?.tryParse(_otp.text) : otp = null;

    /// Makes the OTP call
    Future<PasswordResponse> _futureGetOTP = APIController.getOtp(_email.text, otp: otp);
    _futureGetOTP.then((response) {
      /// Makes the loader to stop rotating
      provider.setLoading(false);

      /// Handles the response
      if (response.statusCode == HTTP_201_CREATED || response.statusCode == HTTP_202_ACCEPTED) {
        _showSnackBar(response.data + appLocalizations.translate('checkEmail') ?? '');
        Future.delayed(Duration(seconds: 2), () {
          provider.setAutoValidate(false, willNotify: false);
          provider.setOTPRequested(true);
        });
      } else if (response.statusCode == HTTP_200_OK && response.data.split('.').length == 3) {
        Utility.saveToken(response.data);
        provider.setNeedsUpdate(true, willNotify: false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      } else {
        if (response.data.contains('Attempt exceeded')) {
          _showSnackBar(response?.data ?? '');
          Future.delayed(Duration(seconds: 1), () {
            provider.setLoading(false, willNotify: false);
            provider.setOTPRequested(false, willNotify: false);
            provider.setAutoValidate(false, willNotify: false);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => OTPLoginScreen(),
              ),
            );
          });
        } else {
          String error = response.data;
          if (error != null && error.isNotEmpty && response.statusCode == 0) {
            error = appLocalizations.translate(error);
          }

          _showSnackBar(error);
        }
      }
    });
  }

  /// Shows a toast with message [message]
  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message ?? '')),
    );
  }
}

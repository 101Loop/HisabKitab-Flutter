import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/api_controller/login_api_controller.dart';
import 'package:hisabkitab/src/mixins/validator.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/utils/app_localizations.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> with ValidationMixin {
  double deviceHeight;
  double deviceWidth;
  AppState provider;

  final _formKey = GlobalKey<FormState>();

  String _password;
  String _confirmedPassword;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  AppLocalizations appLocalizations;

  @override
  void initState() {
    super.initState();
    var _provider = Provider.of<AppState>(context, listen: false);
    _provider.initialState();
  }

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
                        headerText: appLocalizations.translate('changePassword'),
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
                        color: Constants.profileBG,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  String result = validatePassword(value);
                                  if (result != null)
                                    return appLocalizations.translate(result);
                                  else
                                    return result;
                                },
                                onSaved: (value) {
                                  _password = value;
                                },
                                autovalidate: provider.autoValidate,
                                obscureText: true,
                                cursorColor: Constants.primaryColor,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  errorMaxLines: 3,
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                  fillColor: Colors.white,
                                  hintText: appLocalizations.translate('newPassword'),
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
                                onSaved: (value) {
                                  _confirmedPassword = value;
                                },
                                validator: (value) {
                                  String result = validateField(value);
                                  if (result != null)
                                    return appLocalizations.translate(result);
                                  else
                                    return result;
                                },
                                obscureText: true,
                                autovalidate: provider.autoValidate,
                                cursorColor: Constants.primaryColor,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                  fillColor: Colors.white,
                                  hintText: appLocalizations.translate('confirmPassword'),
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
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: deviceWidth * 0.75,
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: HeaderWidget(
                          headerText: appLocalizations.translate('updatePassword'),
                          maxFontSize: 19,
                          minFontSize: 17,
                          textColor: Colors.white,
                        ),
                        color: Constants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(
                            color: Constants.primaryColor,
                          ),
                        ),
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
                    valueColor: AlwaysStoppedAnimation<Color>(Constants.primaryColor),
                  ))
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();

    provider.setAutoValidate(false, willNotify: false);
  }

  ///submits the data and performs API call, if everything's fine
  void _submit() {
    provider.setAutoValidate(true);
    final _formState = _formKey.currentState;

    if (_formState.validate()) {
      provider.setLoading(true);
      FocusScope.of(context).unfocus();
      _formState.save();

      if (_password == _confirmedPassword) {
        LoginAPIController.updatePassword(_password).then((response) {
          provider.setLoading(false, willNotify: false);
          if (response.statusCode == Constants.HTTP_202_ACCEPTED || response.statusCode == Constants.HTTP_200_OK) {
            _showSnackBar(response.data ?? appLocalizations.translate('passwordUpdatedSuccessfully'));

            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop();
            });
          } else {
            provider.setLoading(false);
            String error = response.data;
            if (error != null && error.isNotEmpty) {
              if (response.statusCode == 0) {
                error = appLocalizations.translate(error);
              }
            } else {
              error = appLocalizations.translate('serverError');
            }

            _showSnackBar(error);
          }
        });
      } else {
        provider.setLoading(false);
        _showSnackBar(appLocalizations.translate('passwordMustMatch'));
      }
    }
  }

  ///displays SnackBar
  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

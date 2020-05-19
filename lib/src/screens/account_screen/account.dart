import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/main.dart';
import 'package:hisabkitab/src/api_controller/api_controller.dart';
import 'package:hisabkitab/src/mixins/validator.dart';
import 'package:hisabkitab/src/models/user_profile.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/account_screen/change_password.dart';
import 'package:hisabkitab/src/screens/account_screen/welcome_screen.dart';
import 'package:hisabkitab/utils/app_localizations.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:hisabkitab/utils/utility.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  final Function languageUpdateCallback;

  Account({Key key, @required this.languageUpdateCallback}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with ValidationMixin {
  double deviceHeight;
  double deviceWidth;

  AppState provider;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  String _name;
  String _mobile;
  String _email;

  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  AppLocalizations appLocalizations;

  List<Map<String, String>> availableLangList = List();

  String _currentSelectedLang = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAvailableLangs();
      _currentSelectedLang = prefs.getString('languageCode');

      AppState initStateProvider = Provider.of<AppState>(context, listen: false);
      if (initStateProvider.userProfile == null)
        APIController.getUserProfile().then(
          (response) {
            if (response != null) {
              initStateProvider.setUserProfile(response, willNotify: false);

              _nameController.text = response.name;
              _emailController.text = response.email;
              _mobileController.text = response.mobile;

              List<String> name = response.name?.split(' ');
              if (name != null) {
                if (name.length == 1) {
                  initStateProvider.setInitials(name[0][0].toUpperCase());
                } else if (name.length > 1) {
                  initStateProvider.setInitials((name[0][0] + name[1][0]).toUpperCase());
                }
              }
            }
          },
        );
      else {
        UserProfile userProfile = initStateProvider.userProfile;
        _nameController.text = userProfile.name;
        _emailController.text = userProfile.email;
        _mobileController.text = userProfile.mobile;

        List<String> name = userProfile.name?.split(' ');
        if (name != null) {
          if (name.length == 1) {
            initStateProvider.setInitials(name[0][0].toUpperCase());
          } else if (name.length > 1) {
            initStateProvider.setInitials((name[0][0] + name[1][0]).toUpperCase());
          }
        }
      }
    });
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
        backgroundColor: Constants.profileBG,
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              appLocalizations.translate('profile'),
                              style: GoogleFonts.roboto(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showLanguageChangeDialog();
                          },
                          child: LanguageBtn(),
                        )
                      ],
                    ),
                    SizedBox(height: 50.0),
                    Container(
                      padding: EdgeInsets.all(3.0),
                      width: deviceWidth,
                      height: 110.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/images/hisabkitabUIProfile.png'),
                      )),
                      child: CircleAvatar(
                        radius: 45.0,
                        backgroundColor: Constants.lightGreen.withRed(210),
                        child: Center(
                          child: HeaderWidget(
                            headerText: provider.initials,
                            maxFontSize: 32,
                            minFontSize: 30,
                            textColor: Constants.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    HeaderWidget(
                      headerText: provider.userProfile?.name ?? appLocalizations.translate('unknown'),
                      maxFontSize: 22,
                      minFontSize: 20,
                      textColor: Colors.black,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      width: deviceWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _nameController,
                                onSaved: (value) {
                                  _name = value;
                                },
                                cursorColor: Constants.primaryColor,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                  fillColor: Colors.white,
                                  hintText: appLocalizations.translate('name'),
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
                                controller: _mobileController,
                                onSaved: (value) {
                                  _mobile = value;
                                },
                                validator: (value) {
                                  String result = validateMobile(value);
                                  if (result != null)
                                    return appLocalizations.translate(result);
                                  else
                                    return result;
                                },
                                cursorColor: Constants.primaryColor,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                  fillColor: Colors.white,
                                  hintText: appLocalizations.translate('mobile'),
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
                                controller: _emailController,
                                onSaved: (value) {
                                  _email = value;
                                },
                                validator: (value) {
                                  String result = validateEmail(value);
                                  if (result != null)
                                    return appLocalizations.translate(result);
                                  else
                                    return result;
                                },
                                cursorColor: Constants.primaryColor,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                  fillColor: Colors.white,
                                  hintText: appLocalizations.translate('emailId'),
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
                      height: 45.0,
                      child: RaisedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: HeaderWidget(
                          headerText: appLocalizations.translate('updateProfile'),
                          maxFontSize: 20,
                          minFontSize: 18,
                          textColor: Colors.white,
                        ),
                        color: Constants.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(
                            color: Constants.buttonColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Text(
                          appLocalizations.translate('changePassword') + ' ?',
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
                      height: 45.0,
                      child: OutlineButton(
                        borderSide: BorderSide(
                          color: Constants.primaryColor,
                        ),
                        onPressed: () {
                          _logout();
                        },
                        child: HeaderWidget(
                          headerText: appLocalizations.translate('logout'),
                          maxFontSize: 20,
                          minFontSize: 18,
                          textColor: Constants.primaryColor,
                        ),
                        color: Constants.primaryColor,
                        splashColor: Constants.lightGreen.withRed(210),
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
            provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Constants.primaryColor),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();

    provider.setLoading(false, willNotify: false);
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }

  ///shows a [SnackBar], displaying [message]
  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  ///validate form and submit the response
  void _submit() {
    FocusScope.of(context).unfocus();
    final _formState = _formKey.currentState;

    if (_formState.validate()) {
      _formState.save();

      if ((_name != null && _name.isNotEmpty) || (_mobile != null && _mobile.isNotEmpty) || (_email != null && _email.isNotEmpty)) {
        provider.setLoading(true);
        UserProfile userProfile = UserProfile(name: _name, mobile: _mobile, email: _email);

        APIController.updateUserProfile(userProfile).then((response) {
          provider.setLoading(false);
          if (response.error?.isNotEmpty ?? false) {
            if (response.error.contains('This mobile number is already registered')) {
              _showSnackBar(appLocalizations.translate('alreadyExistingError'));
            } else {
              String error = response.error;
              if (response.statusCode == 0) error = appLocalizations.translate(error);

              _showSnackBar(error);
            }
          } else {
            _showSnackBar(appLocalizations.translate('profileUpdated'));

            List<String> name = response.name?.split(' ');
            if (name != null) {
              if (name.length == 1) {
                provider.setInitials(name[0][0].toUpperCase(), willNotify: false);
              } else if (name.length > 1) {
                provider.setInitials((name[0][0] + name[1][0]).toUpperCase(), willNotify: false);
              }
            }

            provider.setUserProfile(response);
          }
        });
      }
    }
  }

  ///clears provider and preference's data
  void _logout() {
    provider.clearData();
    Utility.deleteToken();
    prefs.clear();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(),
      ),
    );
  }

  /// displays dialog to change location
  Future<bool> _showLanguageChangeDialog() {
    return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              title: Text(appLocalizations.translate('changeLanguage')),
              contentPadding: const EdgeInsets.all(5.0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 10),
                  Container(
                    width: 300,
                    height: 150,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: availableLangList.length,
                      itemBuilder: _langOptionItemBuilder,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(appLocalizations.translate('cancel')),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// gets available languages from langs.json file
  void _getAvailableLangs() async {
    availableLangList.clear();
    var langJsonString = await rootBundle.loadString('lang/langs.json');
    List langList = json.decode(langJsonString);
    langList.forEach((item) {
      Map<String, String> map = (item as Map).map((key, value) => MapEntry(key, value != null ? value.toString() : null));
      availableLangList.add(map);
    });
  }

  /// item widget builder, creates a LanguageOption widget
  Widget _langOptionItemBuilder(BuildContext context, int index) {
    String language = availableLangList[index]['language'];
    String languageCode = availableLangList[index]['languageCode'];

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _currentSelectedLang = languageCode;
            prefs.setString('languageCode', languageCode);
            appLocalizations.load();
            setState(() {});
            widget.languageUpdateCallback();
            Navigator.of(context).pop();
          },
          child: LanguageOption(language: language, isSelected: languageCode == _currentSelectedLang),
        ),
        index != availableLangList.length - 1 ? Divider() : Container()
      ],
    );
  }
}

/// stateless widget for language option
class LanguageOption extends StatelessWidget {
  final String language;    // language to be shown
  final bool isSelected;    // bool to highlight the selected language

  LanguageOption({this.language, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Align(
          alignment: Alignment.center,
          heightFactor: 1.5,
          widthFactor: 1.5,
          child: Text(
            language,
            style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }
}

/// stateless widget for language change button
class LanguageBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.language,
      color: Colors.black54,
    );
  }
}

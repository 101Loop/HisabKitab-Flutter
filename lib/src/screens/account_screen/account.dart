import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/main.dart';
import 'package:hisabkitab/src/api_controller/login_api_controller.dart';
import 'package:hisabkitab/src/mixins/validator.dart';
import 'package:hisabkitab/src/models/user_profile.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/account_screen/change_password.dart';
import 'package:hisabkitab/src/screens/account_screen/welcome_screen.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:hisabkitab/utils/utility.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppState initStateProvider = Provider.of<AppState>(context, listen: false);
      if (initStateProvider.userProfile == null)
        LoginAPIController.getUserProfile().then(
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Constants.lightGreen.withRed(210),
                              ),
                              height: 35.0,
                              width: 35.0,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Constants.primaryColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    provider.setCurrentTab(0);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Text(
                              'Profile',
                              style: GoogleFonts.roboto(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Container(
                      padding: EdgeInsets.all(3.0),
                      width: deviceWidth,
                      height: 110.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.contain,
                        image:
                            AssetImage('assets/images/hisabkitabUIProfile.png'),
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
                      headerText: provider.userProfile?.name ?? 'Unknown',
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
                              margin:
                                  EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _mobileController,
                                onSaved: (value) {
                                  _mobile = value;
                                },
                                validator: validateNullableMobile,
                                cursorColor: Constants.primaryColor,
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
                              margin:
                                  EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _emailController,
                                onSaved: (value) {
                                  _email = value;
                                },
                                validator: validateNullableEmail,
                                cursorColor: Constants.primaryColor,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                  fillColor: Colors.white,
                                  hintText: 'Email-ID',
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
                          headerText: 'Update Profile',
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
                          'Change Password?',
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
                          headerText: 'LOGOUT',
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Constants.primaryColor),
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
    final _formState = _formKey.currentState;

    if (_formState.validate()) {
      _formState.save();

      if ((_name != null && _name.isNotEmpty) ||
          (_mobile != null && _mobile.isNotEmpty) ||
          (_email != null && _email.isNotEmpty)) {
        provider.setLoading(true);
        UserProfile userProfile =
            UserProfile(name: _name, mobile: _mobile, email: _email);

        LoginAPIController.updateUserProfile(userProfile).then((response) {
          provider.setLoading(false);
          if (response.error?.isNotEmpty ?? false) {
            _showSnackBar(response.error);
          } else {
            _showSnackBar('Profile updated successfully');

            List<String> name = response.name?.split(' ');
            if (name != null) {
              if (name.length == 1) {
                provider.setInitials(name[0][0].toUpperCase(),
                    willNotify: false);
              } else if (name.length > 1) {
                provider.setInitials((name[0][0] + name[1][0]).toUpperCase(),
                    willNotify: false);
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
}

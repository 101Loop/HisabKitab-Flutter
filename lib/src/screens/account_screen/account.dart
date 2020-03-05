import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/screens/account_screen/change_password.dart';
import 'package:hisabkitab/src/screens/account_screen/welcome_screen.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  double deviceHeight;
  double deviceWidth;
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: profileBG,
        body: Container(
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
                            color: lightGreen.withRed(210),
                          ),
                          height: 35.0,
                          width: 35.0,
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: primaryColor,
                                size: 20,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
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
                    image: AssetImage('assets/images/hisabkitabUIProfile.png'),
                  )),
                  child: CircleAvatar(
                    radius: 45.0,
                    backgroundColor: lightGreen.withRed(210),
                    child: Center(
                      child: HeaderWidget(
                        headerText: 'JD',
                        maxFontSize: 32,
                        minFontSize: 30,
                        textColor: primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                HeaderWidget(
                  headerText: 'John Dave',
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
                  child: Column(
                    children: <Widget>[
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
                          cursorColor: primaryColor,
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
                            hintText: 'Address',
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
                  height: 45.0,
                  child: RaisedButton(
                    onPressed: () {},
                    child: HeaderWidget(
                      headerText: 'Update Profile',
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
                  height: 50.0,
                  child: OutlineButton(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ),
                      );
                    },
                    child: HeaderWidget(
                      headerText: 'LOGOUT',
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
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

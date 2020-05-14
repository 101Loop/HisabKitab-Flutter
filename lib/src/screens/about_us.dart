import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/utils/app_localizations.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  AppState provider;
  double deviceWidth;
  AppLocalizations appLocalizations;

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('unable to launch $command');
    }
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
    deviceWidth = MediaQuery.of(context).size.width;
    provider = Provider.of<AppState>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      appLocalizations.translate('aboutUs'),
                      style: GoogleFonts.roboto(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    HeaderWidget(
                      headerText: appLocalizations.translate('appName'),
                      maxFontSize: 25,
                      minFontSize: 25,
                      textColor: Colors.black,
                    ),
                    Container(
                      height: 140.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/addTransactionImage.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: HeaderWidget(
                    headerText: appLocalizations.translate('aboutUsPara'),
                    maxFontSize: 15,
                    minFontSize: 15,
                    textColor: Colors.black,
                  ),
                ),
                SizedBox(height: 60.0),
                Container(
                  width: deviceWidth * 0.75,
                  height: 50.0,
                  margin: EdgeInsets.only(right: 10.0),
                  child: OutlineButton(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                    onPressed: () {
                      customLaunch('mailto:help@vithartha.com?subject=Regarding%20HisabKitab');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.mail,
                          color: primaryColor,
                        ),
                        SizedBox(width: 10.0),
                        HeaderWidget(
                          headerText: appLocalizations.translate('emailUs'),
                          maxFontSize: 20,
                          minFontSize: 18,
                          textColor: primaryColor,
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    splashColor: lightGreen.withRed(210),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: deviceWidth * 0.75,
                  height: 50.0,
                  margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                  child: OutlineButton(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                    onPressed: () {
                      customLaunch('tel: +911204545647');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.phone,
                          color: primaryColor,
                        ),
                        SizedBox(width: 10.0),
                        HeaderWidget(
                          headerText: appLocalizations.translate('callUs'),
                          maxFontSize: 20,
                          minFontSize: 18,
                          textColor: primaryColor,
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    splashColor: lightGreen.withRed(210),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();

    provider.setLoading(false, willNotify: false);
  }
}

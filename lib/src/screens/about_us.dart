import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:provider/provider.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  AppState provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppState>(context);
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
                                provider.setCurrentTab(0);
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Text(
                          'Hisab Kitab (हिसाब किताब)',
                          style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

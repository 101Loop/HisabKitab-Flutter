import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderWidget extends StatelessWidget {
  final String headerText;
  final double fontSize;
  final Color textColor;
  @override
  const HeaderWidget(
      {Key key,
      @required this.headerText,
      @required this.fontSize,
      @required this.textColor})
      : super(key: key);
  Widget build(BuildContext context) {
    return Text(
      headerText,
      style: GoogleFonts.nunito(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    );
  }
}

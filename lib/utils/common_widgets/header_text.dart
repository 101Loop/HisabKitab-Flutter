import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A common, customized auto size text widget
class HeaderWidget extends StatelessWidget {
  /// Text string to be shown
  final String headerText;

  /// Min. and max. font sizes
  final double maxFontSize;
  final double minFontSize;

  /// Color of the text
  final Color textColor;

  @override
  const HeaderWidget({Key key, @required this.headerText, @required this.textColor, @required this.maxFontSize, @required this.minFontSize}) : super(key: key);

  Widget build(BuildContext context) {
    return AutoSizeText(
      headerText,
      maxFontSize: maxFontSize,
      minFontSize: minFontSize,
      style: GoogleFonts.nunito(
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    );
  }
}

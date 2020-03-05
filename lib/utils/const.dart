import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const String appName = 'Hisab Kitab';
const Color primaryColor = Color(0xff59c7ba);
const Color buttonColor = Color(0xffe9c33e);
const Color lightGreen = Color(0xffecf8f8);
const Color profileBG = Color(0xfff3f6fc);
MaterialColor primarySwatch = MaterialColor(0xff59c7ba, primaryColorMap);
Map<int, Color> primaryColorMap = {
  50: Color.fromRGBO(73, 2, 36, .1),
  100: Color.fromRGBO(73, 2, 36, .2),
  200: Color.fromRGBO(73, 2, 36, .3),
  300: Color.fromRGBO(73, 2, 36, .4),
  400: Color.fromRGBO(73, 2, 36, .5),
  500: Color.fromRGBO(73, 2, 36, .6),
  600: Color.fromRGBO(73, 2, 36, .7),
  700: Color.fromRGBO(73, 2, 36, .8),
  800: Color.fromRGBO(73, 2, 36, .9),
  900: Color.fromRGBO(73, 2, 36, 1),
};
const List<String> paymentList = [
  'Cash',
  'Cheque',
  'Account Type',
  'Card',
];
const String Spendings = 'Spendings';
const String Earnings = 'Earnings';

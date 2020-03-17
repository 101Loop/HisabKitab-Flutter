import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

///urls
const String BASE_URL = 'https://admin.hisabkitab.in/';
const String LOGIN_URL = BASE_URL + 'api/users/login/';
const String REGISTER_URL = BASE_URL + 'api/users/register/';


/// Strings

const String appName = 'Hisab Kitab';
const String name = "name";
const String email = "email";
const String mobile = "mobile";
const String username = "username";
const String password = "password";
const String Spendings = 'Spendings';
const String Earnings = 'Earnings';
const String TOKEN = "token";

///constants
const String serverError =
    "Server is not responding, Please check your connection and try again later!";

//http codes
const int HTTP_200_OK = 200;
const int HTTP_201_CREATED = 201;
const int HTTP_202_ACCEPTED = 202;
const int HTTP_204_NO_CONTENT = 204;
const int HTTP_403_FORBIDDEN = 403;

/// color codes

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

/// List of dropdowns
const List<String> paymentList = [
  'Cash',
  'Cheque',
  'Account Type',
  'Card',
];

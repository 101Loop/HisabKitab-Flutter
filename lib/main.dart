import 'package:flutter/material.dart';
import 'package:hisab_kitab/pages/login_page.dart';
import 'package:hisab_kitab/pages/signup_page.dart';
import 'package:hisab_kitab/pages/home_page.dart';
import 'package:hisab_kitab/pages/add_credit.dart';
import 'package:hisab_kitab/pages/add_debit.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hisab Kitab',
      routes: <String, WidgetBuilder>{
        '/Signup': (BuildContext context) => new SignUpPage(),
        '/Login': (BuildContext context) => new LoginPage(),
        '/Home': (BuildContext context) => new HomePage(),
        '/Credit': (BuildContext context) => new CreditPage(),
        '/Debit': (BuildContext context) => new DebitPage()
      },
      home: LoginPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hisabkitab/app.dart';
import 'package:hisabkitab/utils/const.dart';

void main() async {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primarySwatch: primarySwatch,
      ),
      home: App(),
    );
  }
}

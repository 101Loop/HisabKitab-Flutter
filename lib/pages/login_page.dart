import 'package:flutter/material.dart';
import 'package:hisab_kitab/ui/raised_gradient_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(30, 80, 0, 0),
            child: new Text('Sign In',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    foreground: Paint()..shader = linearGradient)),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(30, 80, 30, 0),
            child: new TextField(
              style: new TextStyle(fontSize: 18, color: Color(0xff515356)),
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle:
                    new TextStyle(fontSize: 18, color: Color(0xffacb0b7)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff89009B)),
                ),
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
            child: new TextField(
              obscureText: true,
              style: new TextStyle(fontSize: 18, color: Color(0xff515356)),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle:
                    new TextStyle(fontSize: 18, color: Color(0xffacb0b7)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff89009B)),
                ),
              ),
            ),
          ),
          new Align(
            alignment: Alignment.centerRight,
            child: new Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 30, 30),
              child: InkWell(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onTap: () {
                  print('Forgot password clicked');
                },
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
            child: new RaisedGradientButton(
              height: 60.0,
              child: new Text(
                'Login'.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              gradient: gradient(Color(0xff89009B), Color(0xffC52E63)),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/Home');
              },
            ),
          ),
          new Expanded(
            child: new Align(
                alignment: Alignment.bottomCenter,
                child: new Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text('New User? '),
                      new GestureDetector(
                        child: new Text(
                          'Signup',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/Signup');
                        },
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xff89009B), Color(0xffC52E63)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

Gradient gradient(Color color1, Color color2) {
  return LinearGradient(
    colors: <Color>[color1, color2],
  );
}

import 'package:flutter/material.dart';
import 'package:hisab_kitab/ui/raised_gradient_button.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(30, 80, 0, 0),
            child: new Text('Sign Up',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    foreground: Paint()..shader = linearGradient)),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
            child: new TextField(
              style: new TextStyle(fontSize: 18, color: Color(0xff515356)),
              decoration: InputDecoration(
                hintText: 'Name',
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
              style: new TextStyle(fontSize: 18, color: Color(0xff515356)),
              decoration: InputDecoration(
                hintText: 'Phone',
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
          new Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
            child: new TextField(
              obscureText: true,
              style: new TextStyle(fontSize: 18, color: Color(0xff515356)),
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                hintStyle:
                    new TextStyle(fontSize: 18, color: Color(0xffacb0b7)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff89009B)),
                ),
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
            child: new RaisedGradientButton(
              height: 60.0,
              child: new Text(
                'SignUp'.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              gradient: gradient(Color(0xff89009B), Color(0xffC52E63)),
              onPressed: () => print('Signup Button clicked.'),
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
                      new Text('Already a User? '),
                      new InkWell(
                        child: new Text(
                          'Login',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/Login');
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

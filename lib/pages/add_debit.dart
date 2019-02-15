import 'package:flutter/material.dart';

class DebitPage extends StatefulWidget {
  @override
  _DebitPageState createState() => _DebitPageState();
}

class _DebitPageState extends State<DebitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Debit'),
      ),
      body: new Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(30, 80, 30, 0),
            child: new TextField(
              style: new TextStyle(fontSize: 18, color: Color(0xff515356)),
              decoration: InputDecoration(
                hintText: 'Transaction Name',
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
                hintText: 'Amount',
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
                hintText: 'Description',
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
              onTap: () async {
                DateTime date = await showDatePicker(context: context,
                    initialDate: new DateTime.now(), firstDate: new DateTime(1990),
                    lastDate: new DateTime(2030));
              },
              style: new TextStyle(fontSize: 18, color: Color(0xff515356)),
              decoration: InputDecoration(
                hintText: 'Date',
                enabled: true,

                icon: Icon(Icons.calendar_today),
                hintStyle:
                new TextStyle(fontSize: 18, color: Color(0xffacb0b7)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff89009B)),
                ),
              ),
            ),
          ),
          new Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: new RaisedButton(
                  onPressed: () => print('clicked'),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Text('SUBMIT')),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/const.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List itemList = List();

  @override
  Widget build(BuildContext context) {
    List itemList = [
      ListCard(
        icon: Icons.shopping_cart,
        name: 'Groceries',
        amount: '-₹20',
      ),
      ListCard(
        icon: Icons.shutter_speed,
        name: 'Clock',
        amount: '-₹1020',
      ),
      ListCard(
        icon: Icons.smartphone,
        name: 'Phone',
        amount: '-₹20000',
      ),
      ListCard(
        icon: Icons.school,
        name: 'School Fee',
        amount: '-₹1500',
      ),
      ListCard(
        icon: Icons.scanner,
        name: 'Wifi bill',
        amount: '-₹1800',
      ),
      ListCard(
        icon: Icons.restaurant,
        name: 'Eating out',
        amount: '-₹900',
      ),
    ];
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: lightGreen.withRed(210),
            ),
            height: 30.0,
            width: 30.0,
            child: Center(
              child: Text(
                '::',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.8,
                    fontSize: 18.0),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          HeaderWidget(
            headerText: 'Total balance',
            fontSize: 25.0,
            textColor: Colors.black,
          ),
          SizedBox(height: 10.0),
          GreenCard(
            totalBalance: '6522.92',
          ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              HeaderWidget(
                headerText: 'Latest spending',
                fontSize: 22.0,
                textColor: Colors.black,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.sort),
                    color: primaryColor,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    color: primaryColor,
                    onPressed: () {
                      
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return itemList[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GreenCard extends StatelessWidget {
  GreenCard({
    @required this.totalBalance,
    Key key,
  }) : super(key: key);

  final String totalBalance;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: deviceWidth,
        maxHeight: deviceHeight * 0.2,
        minHeight: deviceHeight * 0.15,
        minWidth: deviceWidth * 0.7,
      ),
      child: Container(
        height: deviceHeight * 0.2,
        width: deviceWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: primaryColor,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 40,
              top: 80,
              child: Container(
                height: 20.0,
                width: 20.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xff6bcdc0),
                ),
              ),
            ),
            Positioned(
              left: 220,
              top: 20,
              child: Container(
                height: 20.0,
                width: 20.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xff6bcdc0),
                ),
              ),
            ),
            Positioned(
              left: 345,
              top: 110,
              child: Container(
                height: 20.0,
                width: 20.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xff6bcdc0),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      '₹',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  SizedBox(width: 5.0),
                  HeaderWidget(
                      headerText: totalBalance,
                      fontSize: 30,
                      textColor: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListCard extends StatelessWidget {
  const ListCard({
    Key key,
    @required this.icon,
    @required this.name,
    this.amount,
  }) : super(key: key);
  final IconData icon;
  final String name;
  final String amount;
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      padding: EdgeInsets.all(15.0),
      width: deviceWidth,
      height: deviceHeight * 0.10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Color(0xffecf8f8).withRed(210),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                icon,
                color: Colors.black45,
                size: 20.0,
              ),
              SizedBox(width: 20.0),
              Text(
                name,
                style: GoogleFonts.nunito(
                  color: Colors.black45,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: GoogleFonts.nunito(
              color: Colors.red.shade300,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

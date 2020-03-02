import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/screens/account.dart';
import 'package:hisabkitab/src/screens/add_transaction.dart';
import 'package:hisabkitab/src/screens/dashboard.dart';
import 'package:hisabkitab/src/screens/settings.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget addExpense() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddTransaction(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Add Expense',
          style: GoogleFonts.nunito(
            color: Colors.white,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: buttonColor,
        ),
      ),
    );
  }

  Widget addEarning() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddTransaction(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Add Earning',
          style: GoogleFonts.nunito(
            color: Colors.white,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: buttonColor,
        ),
      ),
    );
  }

  final Key dashboardKey = PageStorageKey('dashboard');
  final Key accountKey = PageStorageKey('account');
  final Key settingsKey = PageStorageKey('settings');

  Dashboard dashboard;
  Account account;
  Setting setting;

  double deviceHeight;
  double deviceWidth;
  List<Widget> pages;
  int currentTab = 0;
  int currentIndex;
  @override
  void initState() {
    super.initState();
    dashboard = Dashboard(
      key: dashboardKey,
    );
    account = Account(
      key: accountKey,
    );
    setting = Setting(
      key: settingsKey,
    );
    pages = [
      dashboard,
      account,
      setting,
    ];
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Stack(
          children: <Widget>[
            Positioned(
              right: 5.0,
              bottom: 20.0,
              child: AnimatedFloatingActionButton(
                fabButtons: <Widget>[
                  addEarning(),
                  addExpense(),
                ],
                colorEndAnimation: buttonColor,
                colorStartAnimation: buttonColor,
                animatedIconData: AnimatedIcons.close_menu,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            onTap: (int value) {
              setState(() {
                currentTab = value;
              });
            },
            currentIndex: currentTab,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                title: Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                title: Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Container(),
                title: Text(
                  '',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            backgroundColor: primaryColor,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black38,
          ),
        ),
        body: pages[currentTab],
      ),
    );
  }
}

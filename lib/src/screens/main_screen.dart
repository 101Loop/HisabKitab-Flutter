import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/api_controller/login_api_controller.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/about_us.dart';
import 'package:hisabkitab/src/screens/account_screen/account.dart';
import 'package:hisabkitab/src/screens/add_transaction.dart';
import 'package:hisabkitab/src/screens/dashboard.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool addTranscationClicked = false;

  Widget addExpense() {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AddTransaction(
              transactionType: 'Add expense',
            ),
          ),
        );
        setState(() {
          addTranscationClicked = false;
        });
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
      onTap: () async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AddTransaction(
              transactionType: 'Add earning',
            ),
          ),
        );
        setState(() {
          addTranscationClicked = false;
        });
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
  final Key aboutUsKey = PageStorageKey('aboutUs');
  Dashboard dashboard;
  Account account;
  AboutUs aboutUs;

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
    aboutUs = AboutUs(
      key: aboutUsKey,
    );

    pages = [
      dashboard,
      account,
      aboutUs,
    ];

    LoginAPIController.getUserProfile().then((response) {
      if (response != null) Provider.of<AppState>(context, listen: false).setUserProfile(response, willNotify: false);
    });
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
              right: 10.0,
              bottom: 15.0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    addTranscationClicked = !addTranscationClicked;
                  });
                },
                child: Container(
                  height: 60,
                  width: 60,
                  child: !addTranscationClicked
                      ? Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 29,
                        )
                      : Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: buttonColor,
                  ),
                ),
              ),
            ),
            addTranscationClicked
                ? Positioned(
                    bottom: 100,
                    right: 10,
                    child: Column(
                      children: <Widget>[
                        addExpense(),
                        SizedBox(height: 20.0),
                        addEarning(),
                      ],
                    ),
                  )
                : Container(),
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
              if (value == 3) {
                return;
              } else {
                setState(() {
                  currentTab = value;
                });
              }
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
                icon: Icon(Icons.info_outline),
                title: Text(
                  'About Us',
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

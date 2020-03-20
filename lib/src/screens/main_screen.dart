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
  AppState provider;

  Widget addExpense() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AddTransaction(
              transactionType: 'Add expense',
              category: 'Debit',
            ),
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
        provider.setTransactionClicked(false, willNotify: false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AddTransaction(
              transactionType: 'Add earning',
              category: 'Credit',
            ),
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
  final Key aboutUsKey = PageStorageKey('aboutUs');
  Dashboard dashboard;
  Account account;
  AboutUs aboutUs;

  double deviceHeight;
  double deviceWidth;
  List<Widget> pages;
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
    provider = Provider.of<AppState>(context);
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Stack(
          children: <Widget>[
            Positioned(
              right: 10.0,
              bottom: 15.0,
              child: provider.currentTab == 0
                  ? GestureDetector(
                      onTap: () {
                        provider.setTransactionClicked(!provider.addTransactionClicked);
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        child: !provider.addTransactionClicked
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
                    )
                  : GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: buttonColor,
                        ),
                      ),
                    ),
            ),
            provider.addTransactionClicked
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
                provider.setCurrentTab(value, willNotify: false);
                provider.setTransactionClicked(false);
              }
            },
            currentIndex: provider.currentTab,
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
        body: pages[provider.currentTab],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/about_us.dart';
import 'package:hisabkitab/src/screens/account_screen/account.dart';
import 'package:hisabkitab/src/screens/add_transaction.dart';
import 'package:hisabkitab/src/screens/dashboard.dart';
import 'package:hisabkitab/utils/app_localizations.dart';
import 'package:hisabkitab/utils/baked_icons/rupee_icon_icons.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AppState provider;

  AppLocalizations appLocalizations;

  Widget addExpense() {
    return GestureDetector(
      onTap: () async {
        _navigateToTransactionScreen('addExpense', 'debit');
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          appLocalizations.translate('addExpense'),
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
        _navigateToTransactionScreen('addEarning', 'credit');
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          appLocalizations.translate('addEarning'),
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
        languageUpdateCallback: () {
          setState(() {});
        });
    aboutUs = AboutUs(
      key: aboutUsKey,
    );

    pages = [
      dashboard,
      account,
      aboutUs,
    ];
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
    provider = Provider.of<AppState>(context);
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
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
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/images/hisab_kitab_logo.png'),
                            ),
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
              key: ValueKey('bottomNavBar'),
              onTap: (int value) {
                if (value != 3) {
                  provider.setLoading(false, willNotify: false);
                  provider.setCurrentTab(value, willNotify: false);
                  provider.setTransactionClicked(false, willNotify: false);
                  provider.setNeedsUpdate(false, willNotify: false);
                  provider.setCurrentPage(pages[value]);
                }
              },
              currentIndex: provider.currentTab,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(RupeeIcon.rupee_icon, size: 18),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      appLocalizations.translate('dashboard'),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  title: Text(
                    appLocalizations.translate('account'),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline),
                  title: Text(
                    appLocalizations.translate('aboutUs'),
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
      ),
    );
  }

  ///method, called on back pressed
  Future<bool> _onBackPressed() async {
    //exit the app if already on 1st tab
    if (provider.currentPage == dashboard) {
      _showAlertDialog(
        appLocalizations.translate('confirm'),
        appLocalizations.translate('areYouSure'),
        () {
          SystemNavigator.pop();
        },
      );
    }

    //switch to the 1st tab for other cases
    else {
      provider.setCurrentTab(0, willNotify: false);
      provider.setCurrentPage(dashboard);
    }

    return false;
  }

  void _showAlertDialog(String title, String content, Function callback) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: title != null
              ? Text(title)
              : Container(
                  height: 0,
                ),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Colors.red,
              child: Text(
                appLocalizations.translate('cancel'),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                callback();
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: primaryColor,
              child: Text(
                appLocalizations.translate('ok'),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToTransactionScreen(String transactionType, String category) {
    provider.setTransactionClicked(false, willNotify: false);
    provider.setLoading(false, willNotify: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTransaction(
          transactionType: transactionType,
          category: category,
        ),
      ),
    );
  }
}

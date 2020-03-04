import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/filter_screen.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/common_widgets/sorting_items.dart';
import 'package:hisabkitab/utils/const.dart';
import 'package:hisabkitab/utils/pop_up_items.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List earningItemList = List();
  final List expenseItemList = List();
  final List allTransactions = List();

  double deviceHeight;
  double deviceWidth;

  static List<PopupMenuItem<PopUpItems>> _popItems = popupItems
      .map(
        (PopUpItems val) => PopupMenuItem<PopUpItems>(
          child: Text(val.name),
          value: val,
        ),
      )
      .toList();

  static List<PopupMenuItem<SortingItems>> _sortingItems = sortingItems
      .map(
        (SortingItems val) => PopupMenuItem<SortingItems>(
          child: Text(val.name),
          value: val,
        ),
      )
      .toList();
  AppState provider;
  Future<bool> _onSortPressed() {
    return showDialog(
            context: context,
            builder: (context) {
              provider = Provider.of<AppState>(context);
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        provider.setTransactionType('earnings',
                            willNotify: true);
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            'Earnings',
                            style: GoogleFonts.nunito(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        provider.setTransactionType('spendings',
                            willNotify: true);
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            'Spendings',
                            style: GoogleFonts.nunito(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        provider.setTransactionType('all transaction',
                            willNotify: true);
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            'All Transactions',
                            style: GoogleFonts.nunito(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FilterScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            'More Filter Option',
                            style: GoogleFonts.nunito(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }) ??
        false;
  }

  void _dragEnd(DragEndDetails details) {
    if (details.primaryVelocity < 0)
      reduceCardHeight();
    else
      increaseCardHeight();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    provider = Provider.of<AppState>(context);
    List earningItemList = [
      ListCard(
        icon: Icons.monetization_on,
        name: 'Salary',
        amount: '+₹20000',
        transactionDate: '1/02/2020',
        transactionType: 'In Account',
        comment: 'Salary of Feb',
        type: Earnings,
      ),
    ];
    List expenseItemList = [
      ListCard(
        icon: Icons.shutter_speed,
        name: 'Clock',
        amount: '-₹1020',
        transactionDate: '2/02/2020',
        transactionType: 'Card',
        type: Spendings,
      ),
      ListCard(
        icon: Icons.school,
        name: 'School Fee',
        amount: '-₹1500',
        transactionDate: '2/02/2020',
        transactionType: 'card',
        comment: 'need',
        type: Spendings,
      ),
      ListCard(
        icon: Icons.scanner,
        name: 'Wifi bill',
        amount: '-₹1800',
        transactionDate: '2/02/2020',
        transactionType: 'Cash',
        type: Spendings,
      ),
      ListCard(
        icon: Icons.restaurant,
        name: 'Eating out',
        amount: '-₹900',
        transactionDate: '2/02/2020',
        transactionType: 'Cash',
        type: Spendings,
      ),
    ];
    List allTransactions = [
      ListCard(
        icon: Icons.monetization_on,
        name: 'Salary',
        amount: '+₹20000',
        transactionDate: '1/02/2020',
        transactionType: 'In Account',
        comment: 'Salary of Feb',
        type: Earnings,
      ),
      ListCard(
        icon: Icons.shutter_speed,
        name: 'Clock',
        amount: '-₹1020',
        transactionDate: '2/02/2020',
        transactionType: 'Card',
        type: Spendings,
      ),
      ListCard(
        icon: Icons.school,
        name: 'School Fee',
        amount: '-₹1500',
        transactionDate: '2/02/2020',
        transactionType: 'card',
        comment: 'need',
        type: Spendings,
      ),
      ListCard(
        icon: Icons.scanner,
        name: 'Wifi bill',
        amount: '-₹1800',
        transactionDate: '2/02/2020',
        transactionType: 'Cash',
        type: Spendings,
      ),
      ListCard(
        icon: Icons.restaurant,
        name: 'Eating out',
        amount: '-₹900',
        transactionDate: '2/02/2020',
        transactionType: 'Cash',
        type: Spendings,
      ),
    ];
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.sort),
                    color: primaryColor,
                    onPressed: () {
                      _onSortPressed();
                    },
                  ),
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return _popItems;
                    },
                    child: Icon(
                      Icons.more_vert,
                      color: primaryColor,
                    ),
                    onSelected: (value) {
                      getPopUpItem(value.name);
                      print(value.name);
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0),
          provider.getTransactionType == Earnings
              ? GreenCard(totalBalance: '20000.0')
              : provider.getTransactionType == Spendings
                  ? RedCard(totalBalance: '5220.0')
                  : RedGreenCard(
                      totalEarning: '20000.0',
                      totalExpense: '5220.0',
                    ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              HeaderWidget(
                headerText:
                    '${provider.getPopMenuItem} ${provider.getTransactionType}',
                maxFontSize: 22.0,
                minFontSize: 20.0,
                textColor: Colors.black,
              ),
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return _sortingItems;
                },
                child: Icon(
                  Icons.more_vert,
                  color: primaryColor,
                ),
                onSelected: (value) {},
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: GestureDetector(
              onVerticalDragEnd: _dragEnd,
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: provider.getTransactionType == Earnings
                    ? earningItemList.length
                    : provider.getTransactionType == Spendings
                        ? expenseItemList.length
                        : allTransactions.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key('list'),
                    child: provider.getTransactionType == Earnings
                        ? earningItemList[index]
                        : provider.getTransactionType == Spendings
                            ? expenseItemList[index]
                            : allTransactions[index],
                    direction: DismissDirection.endToStart,
                    onDismissed: (value) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Transaction deleted'),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getPopUpItem(String value) {
    if (value == 'This week (Latest)') {
      provider.setPopMenuItem('Latest', willNotify: true);
    } else if (value == 'This Month') {
      provider.setPopMenuItem('Month', willNotify: true);
    } else if (value == 'This Year') {
      provider.setPopMenuItem('Year', willNotify: true);
    }
  }

  void reduceCardHeight() {
    provider.setCardHeight(deviceHeight * 0.1, willNotify: true);
  }

  void increaseCardHeight() {
    provider.setCardHeight(deviceHeight * 0.2, willNotify: true);
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
    var provider = Provider.of<AppState>(context);
    double deviceWidth = MediaQuery.of(context).size.width;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: deviceWidth,
        minWidth: deviceWidth * 0.7,
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: provider.getCardHeight,
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
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
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
                      maxFontSize: 30,
                      minFontSize: 28,
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

class RedCard extends StatelessWidget {
  RedCard({
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
        minWidth: deviceWidth * 0.7,
      ),
      child: Container(
        height: deviceHeight * 0.2,
        width: deviceWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.red.shade300,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 40,
              top: 80,
              child: Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.red.shade200.withOpacity(0.5),
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
                  color: Colors.red.shade200.withOpacity(0.5),
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
                  color: Colors.red.shade200.withOpacity(0.5),
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
                      maxFontSize: 30,
                      minFontSize: 28,
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

class RedGreenCard extends StatelessWidget {
  RedGreenCard({
    Key key,
    @required this.totalEarning,
    @required this.totalExpense,
  }) : super(key: key);

  final String totalEarning;
  final totalExpense;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppState>(context);
    double deviceWidth = MediaQuery.of(context).size.width;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: deviceWidth,
        minWidth: deviceWidth * 0.7,
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: provider.getCardHeight,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            colors: [primaryColor, Colors.red.shade400],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 40,
              top: 85,
              child: Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
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
                  color: Colors.red.shade200.withOpacity(0.5),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
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
                          headerText: totalEarning,
                          maxFontSize: 28,
                          minFontSize: 25,
                          textColor: Colors.white),
                    ],
                  ),
                  Row(
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
                          headerText: totalExpense,
                          maxFontSize: 28,
                          minFontSize: 25,
                          textColor: Colors.white),
                    ],
                  ),
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
    @required this.amount,
    @required this.transactionType,
    @required this.transactionDate,
    this.comment,
    @required this.type,
  }) : super(key: key);
  final IconData icon;
  final String name;
  final String amount;
  final String transactionType;
  final String transactionDate;
  final String comment;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 7.0, top: 7.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color:
            type == Spendings ? Colors.red.shade100 : lightGreen.withRed(210),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.black45,
                size: 20.0,
              ),
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        name,
                        style: GoogleFonts.nunito(
                          color: Colors.black45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        transactionDate,
                        style: GoogleFonts.nunito(
                          color: Colors.black45,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    comment ?? '',
                    style: GoogleFonts.nunito(
                      color: Colors.black45,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                amount,
                style: GoogleFonts.nunito(
                  color: type != Earnings ? Colors.red.shade300 : primaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                transactionType,
                style: GoogleFonts.nunito(
                  color: Colors.black45,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

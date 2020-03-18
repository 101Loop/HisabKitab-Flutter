import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/api_controller/transaction_api_controller.dart';
import 'package:hisabkitab/src/models/paginated_response.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/filter_screen.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/common_widgets/sorting_items.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double deviceHeight;
  double deviceWidth;

  static List<PopupMenuItem<SortingItems>> _sortingItems = sortingItems
      .map((SortingItems val) =>
          PopupMenuItem<SortingItems>(child: Text(val.name), value: val))
      .toList();
  AppState provider;

  Future<PaginatedResponse> _futureTransactionDetails;

  List<TransactionDetails> _transactionList = List();

  @override
  void initState() {
    super.initState();

    _futureTransactionDetails = TransactionApiController.getTransaction();
    _futureTransactionDetails.then((response) {
      var list = response.results as List;
      List<TransactionDetails> transactionList =
          list.map((item) => TransactionDetails.fromJson(item)).toList();

      double creditAmount = 0;
      double debitAmount = 0;

      transactionList.forEach((item) {
        if (item.category == 'C') {
          creditAmount += item.amount;
        } else {
          debitAmount += item.amount;
        }
      });

      Provider.of<AppState>(context, listen: false)
          .setCreditAmount(creditAmount.toString());
      Provider.of<AppState>(context, listen: false)
          .setDebitAmount(debitAmount.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    provider = Provider.of<AppState>(context);

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Constants.lightGreen.withRed(210),
                    ),
                    height: 50.0,
                    width: 50.0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.sort),
                      color: Constants.primaryColor,
                      onPressed: () {
                        _onSortPressed();
                      },
                    ),
                    PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return _sortingItems;
                      },
                      child: Icon(
                        Icons.more_vert,
                        color: Constants.primaryColor,
                      ),
                      onSelected: (value) {},
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            provider.transactionType == Constants.CREDIT
                ? GreenCard(totalBalance: provider.creditAmount)
                : provider.transactionType == Constants.DEBIT
                    ? RedCard(totalBalance: provider.debitAmount)
                    : RedGreenCard(
                        totalEarning: provider.creditAmount,
                        totalExpense: provider.debitAmount),
            SizedBox(height: 15.0),
            HeaderWidget(
              headerText: provider.transactionType == Constants.CREDIT
                  ? 'Earnings'
                  : 'Spending',
              maxFontSize: 22.0,
              minFontSize: 20.0,
              textColor: Colors.black,
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: FutureBuilder(
                future: _futureTransactionDetails,
                builder: (BuildContext context,
                    AsyncSnapshot<PaginatedResponse> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    provider.setIsLoading(false, willNotify: false);

                    var list = snapshot.data.results as List;
                    _transactionList = list
                        .map((item) => TransactionDetails.fromJson(item))
                        .toList();

                    if (provider.transactionType == Constants.CREDIT) {
                      _transactionList.removeWhere(
                          (item) => item.category != Constants.CREDIT);
                    } else if (provider.transactionType == Constants.DEBIT) {
                      _transactionList.removeWhere(
                          (item) => item.category == Constants.CREDIT);
                    }
                  } else {
                    provider.setIsLoading(true, willNotify: false);
                  }

                  return provider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _transactionList.length > 0
                          ? _listViewBuilder()
                          : _nothingToShowWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                        provider.setTransactionType('C');
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
                        provider.setTransactionType('D');
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
                        provider.setTransactionType('A');
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

  _listViewBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: _transactionList.length,
      itemBuilder: (context, index) {
        TransactionDetails _currentTransaction = _transactionList[index];

        return Dismissible(
          key: Key(_currentTransaction.id.toString()),
          onDismissed: (value) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Transaction deleted successfully'),
              ),
            );
          },
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  title: Text('Confirm'),
                  content: Text('Are you sure to delete this item?'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        print(_currentTransaction.id);
                        print(_currentTransaction.amount);
                        TransactionApiController.deleteTransaction(
                            _currentTransaction.id);
                        Navigator.of(context).pop(true);
                      },
                      child: Text('DELETE'),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('CANCEL'),
                    ),
                  ],
                );
              },
            );
          },
          child: ListCard(
            icon: Icons.done,
            name: _currentTransaction.contact.name,
            amount: _currentTransaction.amount.toString(),
            transactionType: _currentTransaction.category,
            transactionDate: _currentTransaction.transactionDate,
          ),
          direction: DismissDirection.endToStart,
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
    );
  }

  _nothingToShowWidget() {
    return Center(child: Text('There\'s nothing to show :)'));
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
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: deviceWidth,
        minWidth: deviceWidth * 0.7,
        maxHeight: deviceHeight * 0.11,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Constants.primaryColor,
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
        maxHeight: deviceHeight * 0.11,
      ),
      child: Container(
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
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: deviceWidth,
        minWidth: deviceWidth * 0.7,
        maxHeight: deviceHeight * 0.11,
      ),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            colors: [Constants.primaryColor, Colors.red.shade400],
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
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            '₹',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
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
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            '₹',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
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
  }) : super(key: key);
  final IconData icon;
  final String name;
  final String amount;
  final String transactionType;
  final String transactionDate;
  final String comment;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: 7.0, top: 7.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: transactionType == Constants.DEBIT
            ? Colors.red.shade100
            : Constants.lightGreen.withRed(210),
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
                size: 15.0,
              ),
              SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: deviceWidth * 0.3,
                        child: AutoSizeText(
                          name,
                          minFontSize: 10,
                          maxFontSize: 14,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            color: Colors.black45,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        width: deviceWidth * 0.2,
                        child: AutoSizeText(
                          transactionDate,
                          minFontSize: 10,
                          maxFontSize: 14,
                          maxLines: 1,
                          style: GoogleFonts.nunito(
                            color: Colors.black45,
                            fontWeight: FontWeight.w300,
                          ),
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
              Container(
                width: deviceWidth * 0.19,
                child: AutoSizeText(
                  '₹ ' + amount,
                  minFontSize: 10,
                  maxFontSize: 14,
                  maxLines: 1,
                  style: GoogleFonts.nunito(
                    color: transactionType != Constants.CREDIT
                        ? Colors.red.shade300
                        : Constants.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                width: deviceWidth * 0.15,
                child: AutoSizeText(
                  transactionType == Constants.CREDIT ? 'Credit' : 'Debit',
                  minFontSize: 10,
                  maxFontSize: 14,
                  maxLines: 1,
                  style: GoogleFonts.nunito(
                    color: Colors.black45,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

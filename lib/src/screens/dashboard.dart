import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/api_controller/transaction_api_controller.dart';
import 'package:hisabkitab/src/models/paginated_response.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/add_transaction.dart';
import 'package:hisabkitab/src/screens/filter_screen.dart';
import 'package:hisabkitab/src/screens/main_screen.dart';
import 'package:hisabkitab/utils/baked_icons/earning_icons.dart';
import 'package:hisabkitab/utils/baked_icons/spending_icons.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/common_widgets/sorting_items.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

String compactCurrency(String amount) {
  return NumberFormat.compactCurrency(
    decimalDigits: 1,
    symbol: '',
  ).format(
    double.parse(amount),
  );
}

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin {
  double deviceHeight;
  double deviceWidth;

  static List<PopupMenuItem<SortingItems>> _sortingItems = sortingItems
      .map((SortingItems val) =>
          PopupMenuItem<SortingItems>(child: Text(val.name), value: val))
      .toList();
  AppState provider;

  Future<PaginatedResponse> _futureTransactionDetails;

  String queryParams = '?';

  Map<dynamic, int> _sortSchemeMap = Map();

  int _sortScheme = 0;

  String _next;

  bool _isLoadingItems = false;

  bool _fetchedList = false;

  @override
  void initState() {
    super.initState();
    //sets sort scheme
    for (int i = 0; i < sortingItems.length; i++) {
      _sortSchemeMap.putIfAbsent(sortingItems[i].name, () => i);
    }

    AppState initStateProvider = Provider.of<AppState>(context, listen: false);
    if (initStateProvider.searchQuery.isNotEmpty)
      queryParams += 'search=${initStateProvider.searchQuery}&';
    if (initStateProvider.dateQuery.isNotEmpty)
      queryParams += 'transaction_date=${initStateProvider.dateQuery}&';
    if (initStateProvider.minAmountQuery != null &&
        initStateProvider.minAmountQuery > 0)
      queryParams += 'start_amount=${initStateProvider.minAmountQuery}&';
    if (initStateProvider.maxAmountQuery != null &&
        initStateProvider.maxAmountQuery > 0)
      queryParams += 'end_amount=${initStateProvider.maxAmountQuery}&';
    if (initStateProvider.isCashQuery) queryParams += 'mode=1&';
    if (initStateProvider.isCardQuery) queryParams += 'mode=5&';
    if (initStateProvider.isChequeQuery) queryParams += 'mode=2&';
    if (initStateProvider.isAccountQuery) queryParams += 'mode=3&';

    if (initStateProvider.isEarning) {
      if (initStateProvider.isSpending) {
        initStateProvider.setTransactionType(Constants.ALL_TRANSACTIONS,
            willNotify: false);
      } else {
        queryParams += 'category=C&';
        initStateProvider.setTransactionType(Constants.CREDIT,
            willNotify: false);
      }
    } else {
      if (initStateProvider.isSpending) {
        queryParams += 'category=D&';
        initStateProvider.setTransactionType(Constants.DEBIT,
            willNotify: false);
      }
    }

    _futureTransactionDetails =
        TransactionApiController.getTransaction(queryParams);
    _futureTransactionDetails.then((response) {
      var list = response.results as List;
      List<TransactionDetails> transactionList =
          list?.map((item) => TransactionDetails.fromJson(item))?.toList();

      double creditAmount = 0;
      double debitAmount = 0;

      transactionList?.forEach((item) {
        if (item.category == 'C') {
          creditAmount += item.amount;
        } else {
          debitAmount += item.amount;
        }
      });

      initStateProvider.setCreditAmount(creditAmount.toString(),
          willNotify: false);
      initStateProvider.setDebitAmount(debitAmount.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
                    _haveFilters()
                        ? FlatButton(
                            onPressed: () async {
                              _submit();
                              _clearFilter();
                              provider.setTransactionType('A');
                            },
                            color: Constants.lightGreen.withRed(210),
                            padding: EdgeInsets.all(0),
                            child: Text(
                              'Clear Filters',
                              style: TextStyle(color: Constants.primaryColor),
                            ),
                          )
                        : Container(),
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
                      onSelected: (value) {
                        _sortTransactionList(value);
                      },
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
                  : provider.transactionType == Constants.DEBIT
                      ? 'Expenditures'
                      : 'All Transactions',
              maxFontSize: 22.0,
              minFontSize: 20.0,
              textColor: Colors.black,
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: FutureBuilder(
                future: _futureTransactionDetails,
                builder: (BuildContext context,
                    AsyncSnapshot<PaginatedResponse> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (!_fetchedList && snapshot.hasData) {
                      _fetchedList = true;
                      _next = snapshot.data.next;

                      provider.transactionList?.clear();
                      provider.setLoading(false, willNotify: false);

                      var list = snapshot.data.results as List;
                      provider.setTransactionList(
                          list
                              ?.map((item) => TransactionDetails.fromJson(item))
                              ?.toList(),
                          willNotify: false);

                      if (provider.transactionType == Constants.CREDIT) {
                        provider.transactionList?.removeWhere(
                            (item) => item.category != Constants.CREDIT);
                      } else if (provider.transactionType == Constants.DEBIT) {
                        provider.transactionList?.removeWhere(
                            (item) => item.category == Constants.CREDIT);
                      }
                    } else {
                      provider.setLoading(false, willNotify: false);
                    }
                  } else {
                    provider.setLoading(true, willNotify: false);
                  }

                  return provider.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Constants.primaryColor),
                          ),
                        )
                      : provider.transactionList != null &&
                              provider.transactionList.length > 0
                          ? _listViewBuilder()
                          : _nothingToShowWidget();
                },
              ),
            ),
            provider.isLoadingItems
                ? Center(
                    child: Column(
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Constants.primaryColor),
                        ),
                        SizedBox(height: 5),
                        Text('Please wait...'),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();

    provider.setLoading(false, willNotify: false);
    provider.setTransactionClicked(false, willNotify: false);
  }

  void _clearFilter() {
    searchController.text = '';
    minTextController.text = '';
    maxTextController.text = '';

    provider.setEarning(false, willNotify: false);
    provider.setSpending(false, willNotify: false);
    provider.setSearchQuery('', willNotify: false);
    provider.setDateTime('', willNotify: false);
    provider.setDateQuery('', willNotify: false);
    provider.setMinAmountQuery(-1, willNotify: false);
    provider.setMaxAmountQuery(-1, willNotify: false);
    provider.setCashQuery(false, willNotify: false);
    provider.setCardQuery(false, willNotify: false);
    provider.setChequeQuery(false, willNotify: false);
    provider.setAccountQuery(false);
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen()));
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            'Expenditures',
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen()));
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
                        Navigator.of(context).pushReplacement(
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
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            !provider.isLoadingItems &&
            _next != null &&
            !_isLoadingItems) {
          _isLoadingItems = true;
          _loadMore();
        }
        return true;
      },
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: provider.transactionList?.length,
        itemBuilder: (context, index) {
          TransactionDetails _currentTransaction =
              provider.transactionList?.elementAt(index);

          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => AddTransaction(
                      transactionType: 'Edit Transaction',
                      transaction: _currentTransaction),
                ),
              );
            },
            child: Dismissible(
              key: Key(_currentTransaction.id.toString()),
              onDismissed: (_) async {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen()));
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
                      content: Text('Are you sure?'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            print(_currentTransaction.id);
                            print(_currentTransaction.amount);
                            TransactionApiController.deleteTransaction(
                                _currentTransaction.id);
                            Navigator.of(context).pop(true);

                            provider.transactionList.removeAt(index);
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
                icon: _currentTransaction.category == Constants.CREDIT
                    ? Earning.earning
                    : Spending.spending,
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
            ),
          );
        },
      ),
    );
  }

  _nothingToShowWidget() {
    return Center(child: Text('There\'s nothing to show :)'));
  }

  ///sorts the transaction list, according to [value] received
  ///[value] is a nullable field, make it null to sort it by the previous scheme, if there's no previous scheme
  void _sortTransactionList([SortingItems value]) {
    int sortScheme = value != null ? _sortSchemeMap[value.name] : _sortScheme;
    _sortScheme = sortScheme;

    List<TransactionDetails> _tempList = List.from(provider.transactionList);

    switch (sortScheme) {
      case 0: //name ascending
        _tempList.sort((transaction1, transaction2) => transaction1
            .contact?.name
            ?.compareTo(transaction2.contact?.name ?? ''));
        provider.setTransactionList(_tempList);
        break;
      case 1: //name descending
        _tempList.sort((transaction1, transaction2) => transaction2
            .contact?.name
            ?.compareTo(transaction1.contact?.name ?? ''));
        provider.setTransactionList(_tempList);
        break;
      case 2: //amount high to low
        _tempList.sort((transaction1, transaction2) =>
            transaction2.amount?.compareTo(transaction1.amount ?? 0));
        provider.setTransactionList(_tempList);
        break;
      case 3: //amount low to high
        _tempList.sort((transaction1, transaction2) =>
            transaction1.amount?.compareTo(transaction2.amount ?? 0));
        provider.setTransactionList(_tempList);
        break;
    }
  }

  ///loads more items on scrolling
  void _loadMore() {
    if (_next?.isNotEmpty ?? false) {
      List<TransactionDetails> _tempList = List.from(provider.transactionList);
      provider.setLoadingItems(true);
      TransactionApiController.getTransaction(queryParams, next: _next).then(
        (response) {
          _next = response.next;
          print('$_next should be fetched next');

          var list = response.results as List;
          _tempList.addAll(
              list?.map((item) => TransactionDetails.fromJson(item))?.toList());
          provider.setTransactionList(_tempList, willNotify: false);

          if (provider.transactionType == Constants.CREDIT) {
            provider.transactionList
                .removeWhere((item) => item.category != Constants.CREDIT);
          } else if (provider.transactionType == Constants.DEBIT) {
            provider.transactionList
                .removeWhere((item) => item.category == Constants.CREDIT);
          }
          _isLoadingItems = false;
          provider.setLoadingItems(false);
        },
      );
    }
  }

  @override
  bool get wantKeepAlive => true;

  void _submit() {
    provider.setEarning(provider.isTempEarning, willNotify: false);
    provider.setSpending(provider.isTempSpending, willNotify: false);
    provider.setSearchQuery(provider.tempSearchQuery, willNotify: false);
    provider.setDateQuery(provider.tempDateTime, willNotify: false);
    provider.setMinAmountQuery(provider.tempMinAmountQuery, willNotify: false);
    provider.setMaxAmountQuery(provider.tempMaxAmountQuery, willNotify: false);
    provider.setCashQuery(provider.isTempCashQuery, willNotify: false);
    provider.setCardQuery(provider.isTempCardQuery, willNotify: false);
    provider.setChequeQuery(provider.isTempChequeQuery, willNotify: false);
    provider.setAccountQuery(provider.isTempAccountQuery, willNotify: false);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
  }

  bool _haveFilters() {
    if (provider.isEarning != true &&
        provider.isSpending != true &&
        provider.searchQuery == '' &&
        provider.dateQuery == '' &&
        provider.minAmountQuery == -1 &&
        provider.maxAmountQuery == -1 &&
        provider.isCashQuery != true &&
        provider.isCardQuery != true &&
        provider.isChequeQuery != true &&
        provider.isAccountQuery != true)
      return false;
    else
      return true;
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
                      headerText: compactCurrency(totalBalance),
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
                      headerText: compactCurrency(totalBalance),
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
    final double _earning = double.parse(totalEarning);
    final double _expense = double.parse(totalExpense);
    final _end = _expense > _earning ? Alignment.center : Alignment.centerRight;
    final _begin =
        _earning > _expense ? Alignment.center : Alignment.centerLeft;

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
            begin: _begin,
            end: _end,
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
                            headerText: compactCurrency(totalEarning),
                            maxFontSize: 26,
                            minFontSize: 23,
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
                            headerText: compactCurrency(totalExpense),
                            maxFontSize: 26,
                            minFontSize: 23,
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
                alignment: Alignment.center,
                width: deviceWidth * 0.19,
                child: AutoSizeText(
                  '₹ ' + compactCurrency(amount),
                  minFontSize: 9,
                  maxFontSize: 14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

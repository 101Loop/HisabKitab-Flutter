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
import 'package:hisabkitab/utils/common_widgets/non_animated_page_route.dart';
import 'package:hisabkitab/utils/common_widgets/sorting_items.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

class _DashboardState extends State<Dashboard> with AutomaticKeepAliveClientMixin {
  double deviceHeight;
  double deviceWidth;

  AppState provider;

  Future<PaginatedResponse> _futureTransactionDetails;

  String queryParams = '?';

  String _next;

  bool _isLoadingItems = false;

  bool _fetchedList = false;

  @override
  void initState() {
    super.initState();

    AppState initStateProvider = Provider.of<AppState>(context, listen: false);

    if (initStateProvider.needsUpdate)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (initStateProvider.searchQuery.isNotEmpty) queryParams += 'search=${initStateProvider.searchQuery}&';
        if (initStateProvider.dateQuery.isNotEmpty) queryParams += 'transaction_date=${initStateProvider.dateQuery}&';
        if (initStateProvider.minAmountQuery != null && initStateProvider.minAmountQuery > 0) queryParams += 'start_amount=${initStateProvider.minAmountQuery}&';
        if (initStateProvider.maxAmountQuery != null && initStateProvider.maxAmountQuery > 0) queryParams += 'end_amount=${initStateProvider.maxAmountQuery}&';
        if (initStateProvider.isCashQuery) queryParams += 'mode=1&';
        if (initStateProvider.isCardQuery) queryParams += 'mode=5&';
        if (initStateProvider.isChequeQuery) queryParams += 'mode=2&';
        if (initStateProvider.isAccountQuery) queryParams += 'mode=3&';

        if (initStateProvider.isEarning) {
          if (initStateProvider.isSpending) {
            initStateProvider.setTransactionType(Constants.ALL_TRANSACTIONS, willNotify: false);
          } else {
            queryParams += 'category=C&';
            initStateProvider.setTransactionType(Constants.CREDIT, willNotify: false);
          }
        } else {
          if (initStateProvider.isSpending) {
            queryParams += 'category=D&';
            initStateProvider.setTransactionType(Constants.DEBIT, willNotify: false);
          }
        }

        _futureTransactionDetails = TransactionApiController.getTransaction(queryParams);
        _futureTransactionDetails.then((response) {
          var list = response.results as List;
          List<TransactionDetails> transactionList = list?.map((item) => TransactionDetails.fromJson(item))?.toList();

          double creditAmount = 0;
          double debitAmount = 0;

          transactionList?.forEach((item) {
            if (item.category == 'C') {
              creditAmount += item.amount;
            } else {
              debitAmount += item.amount;
            }
          });

          initStateProvider.setCreditAmount(creditAmount.toString(), willNotify: false);
          initStateProvider.setDebitAmount(debitAmount.toString());
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    print('built dashboard screen');
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
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/hisab_kitab_logo.png'),
                      ),
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
                              provider.setTransactionType('A', willNotify: false);
                              _clearFilter();
                              _submit();
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
                        _onQuickFilterPressed();
                      },
                    ),
                    PopupMenuButton(
                      itemBuilder: _itemSortBuilder,
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
                : provider.transactionType == Constants.DEBIT ? RedCard(totalBalance: provider.debitAmount) : RedGreenCard(totalEarning: provider.creditAmount, totalExpense: provider.debitAmount),
            SizedBox(height: 15.0),
            (provider.transactionType != Constants.CREDIT && provider.transactionType != Constants.DEBIT)
                ? DataAnnotation(
                    earning: provider.creditAmount,
                    expense: provider.debitAmount,
                  )
                : Container(),
            SizedBox(height: 10.0),
            HeaderWidget(
              headerText: provider.transactionType == Constants.CREDIT ? 'Earnings' : provider.transactionType == Constants.DEBIT ? 'Expenditures' : 'All Transactions',
              maxFontSize: 22.0,
              minFontSize: 20.0,
              textColor: Colors.black,
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: provider.needsUpdate
                  ? FutureBuilder(
                      future: _futureTransactionDetails,
                      builder: (BuildContext context, AsyncSnapshot<PaginatedResponse> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (!_fetchedList && snapshot.hasData) {
                            _fetchedList = true;
                            _next = snapshot.data.next;

                            provider.transactionList?.clear();
                            provider.setLoading(false, willNotify: false);

                            var list = snapshot.data.results as List;
                            provider.setTransactionList(list?.map((item) => TransactionDetails.fromJson(item))?.toList(), willNotify: false);
                            provider.setInitialTransactionList(provider.transactionList, willNotify: false);

                            if (provider.transactionType == Constants.CREDIT) {
                              provider.transactionList?.removeWhere((item) => item.category != Constants.CREDIT);
                            } else if (provider.transactionType == Constants.DEBIT) {
                              provider.transactionList?.removeWhere((item) => item.category == Constants.CREDIT);
                            }

                            if (provider.transactionList.length < 10 && _next != null && _next.isNotEmpty) {
                              _loadMore();
                            }
                          } else {
                            provider.setLoading(false, willNotify: false);
                          }
                        } else {
                          provider.setLoading(true, willNotify: false);
                        }

                        return _transactionListView();
                      },
                    )
                  : _transactionListView(),
            ),
            provider.isLoadingItems
                ? Center(
                    child: Column(
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Constants.primaryColor),
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
    provider.setNext(_next, willNotify: false);
  }

  void _clearFilter() {
    searchController.text = '';
    minTextController.text = '';
    maxTextController.text = '';

    provider.setSortScheme(-1, willNotify: false);
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
    provider.setAccountQuery(false, willNotify: false);
    provider.setNeedsUpdate(true, willNotify: false);
  }

  Future<bool> _onQuickFilterPressed() {
    return showDialog(
            context: context,
            builder: (context) {
              provider = Provider.of<AppState>(context);
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                      splashColor: Constants.primaryColor,
                      onPressed: () {
                        _handleQuickFilterPressed('C');
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            'Earnings',
                            style: GoogleFonts.nunito(fontSize: 16.0, fontWeight: !_haveFilters() && provider.transactionType == 'C' ? FontWeight.bold : FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      splashColor: Constants.primaryColor,
                      onPressed: () {
                        _handleQuickFilterPressed('D');
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            'Expenditures',
                            style: GoogleFonts.nunito(fontSize: 16.0, fontWeight: !_haveFilters() && provider.transactionType == 'D' ? FontWeight.bold : FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      splashColor: Constants.primaryColor,
                      onPressed: () {
                        _handleQuickFilterPressed('A');
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            'All Transactions',
                            style: GoogleFonts.nunito(fontSize: 16.0, fontWeight: !_haveFilters() && provider.transactionType == 'A' ? FontWeight.bold : FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      splashColor: Constants.primaryColor,
                      onPressed: () async {
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
                            style: GoogleFonts.nunito(fontSize: 16.0, fontWeight: _haveFilters() ? FontWeight.bold : FontWeight.normal),
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
        if (scrollInfo.metrics.pixels > scrollInfo.metrics.maxScrollExtent - 10 && !provider.isLoadingItems && !_isLoadingItems && (_next != null || provider.next != null)) {
          _isLoadingItems = true;
          _loadMore();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: provider.transactionList?.length,
        itemBuilder: (context, index) {
          TransactionDetails _currentTransaction = provider.transactionList?.elementAt(index);

          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => AddTransaction(transactionType: 'Edit Transaction', transaction: _currentTransaction),
                ),
              );
            },
            child: Dismissible(
              key: Key(_currentTransaction.id.toString()),
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
                            TransactionApiController.deleteTransaction(_currentTransaction.id);
                            Navigator.of(context).pop(true);

                            provider.transactionList.removeAt(index);

                            _refreshScreen();
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
                icon: _currentTransaction.category == Constants.CREDIT ? Earning.earning : Spending.spending,
                name: _currentTransaction.contact.name,
                amount: _currentTransaction.amount.toString(),
                transactionType: _currentTransaction.category,
                transactionDate: _currentTransaction.transactionDate,
                comment: _currentTransaction.comments,
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
    List<TransactionDetails> _tempList = List.from(provider.transactionList);

    //if value is null or user selected the previously selected sort scheme
    //sort the list by name, and make the sorting items unselected
    if (value == null || provider.sortScheme == value.sortScheme) {
      provider.setSortScheme(-1, willNotify: false);
      provider.setTransactionList(provider.initialTransactionList);
      return;
    }

    switch (value.sortScheme) {
      case 0: //name ascending
        _tempList.sort((transaction1, transaction2) => transaction1.contact?.name?.compareTo(transaction2.contact?.name ?? ''));
        provider.setSortScheme(value.sortScheme, willNotify: false);
        provider.setTransactionList(_tempList);
        break;
      case 1: //name descending
        _tempList.sort((transaction1, transaction2) => transaction2.contact?.name?.compareTo(transaction1.contact?.name ?? ''));
        provider.setSortScheme(value.sortScheme, willNotify: false);
        provider.setTransactionList(_tempList);
        break;
      case 2: //amount high to low
        _tempList.sort((transaction1, transaction2) => transaction2.amount?.compareTo(transaction1.amount ?? 0));
        provider.setSortScheme(value.sortScheme, willNotify: false);
        provider.setTransactionList(_tempList);
        break;
      case 3: //amount low to high
        _tempList.sort((transaction1, transaction2) => transaction1.amount?.compareTo(transaction2.amount ?? 0));
        provider.setSortScheme(value.sortScheme, willNotify: false);
        provider.setTransactionList(_tempList);
        break;
    }
  }

  ///loads more items on scrolling
  void _loadMore() {
    String next = !provider.needsUpdate ? provider.next : _next;

    if (next?.isNotEmpty ?? false) {
      List<TransactionDetails> _tempList = List.from(provider.transactionList);
      provider.setLoadingItems(true);
      TransactionApiController.getTransaction(queryParams, next: next).then(
        (response) {
          _isLoadingItems = false;
          provider.setLoadingItems(false, willNotify: false);

          _next = response.next;
          provider.setNext(_next, willNotify: false);
          print('$_next should be fetched next');

          var list = response.results as List;
          _tempList.addAll(list?.map((item) => TransactionDetails.fromJson(item))?.toList());
          provider.setTransactionList(_tempList, willNotify: false);
          provider.setInitialTransactionList(_tempList, willNotify: false);

          if (provider.transactionType == Constants.CREDIT) {
            provider.transactionList.removeWhere((item) => item.category != Constants.CREDIT);
          } else if (provider.transactionType == Constants.DEBIT) {
            provider.transactionList.removeWhere((item) => item.category == Constants.CREDIT);
          }

          if (provider.transactionList.length < 10 && _next != null && _next.isNotEmpty) {
            _loadMore();
          }

          double creditAmount = 0;
          double debitAmount = 0;

          _tempList?.forEach((item) {
            if (item.category == 'C') {
              creditAmount += item.amount;
            } else {
              debitAmount += item.amount;
            }
          });

          provider.setCreditAmount(creditAmount.toString(), willNotify: false);
          provider.setDebitAmount(debitAmount.toString());
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

    _refreshScreen();
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

  List<PopupMenuEntry> _itemSortBuilder(BuildContext context) {
    return sortingItems
        .map((SortingItems val) => PopupMenuItem<SortingItems>(
            child: Text(
              val.name,
              style: TextStyle(fontWeight: provider.sortScheme == val.sortScheme ? FontWeight.bold : FontWeight.normal),
            ),
            value: val))
        .toList();
  }

  Widget _transactionListView() {
    return provider.isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Constants.primaryColor),
            ),
          )
        : provider.transactionList != null && provider.transactionList.length > 0 ? _listViewBuilder() : _nothingToShowWidget();
  }

  ///navigates the user to the same screen to update the views
  void _refreshScreen() {
    provider.setNeedsUpdate(true, willNotify: false);
    Navigator.of(context).pushReplacement(NonAnimatedPageRoute(builder: (BuildContext context) => MainScreen()));
  }

  /// [transactionType] - the type of the transaction to be selected
  /// method basically sets the type of transaction, clears the filter and refreshes the screen with new values
  void _handleQuickFilterPressed(String transactionType) {
    Navigator.of(context).pop();
    provider.setTransactionType(transactionType, willNotify: false);
    _clearFilter();
    _refreshScreen();
  }
}

class DataAnnotation extends StatelessWidget {
  DataAnnotation({Key key, @required this.earning, @required this.expense}) : super(key: key);

  final String earning;
  final String expense;

  String earningPercentage(String earning, String expense) {
    double earningDouble = double.parse(earning);
    double expenseDouble = double.parse(expense);
    double percentage = (earningDouble / (earningDouble + expenseDouble)) * 100;
    return percentage.toStringAsFixed(2);
  }

  String expensePercentage(String earning, String expense) {
    double earningDouble = double.parse(earning);
    double expenseDouble = double.parse(expense);
    double percentage = (expenseDouble / (earningDouble + expenseDouble)) * 100;
    return percentage.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 10,
                  width: 10,
                  color: Constants.primaryColor,
                ),
                SizedBox(width: 20),
                Text(
                  'Earnings',
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
            Text(
              earningPercentage(earning, expense) == 'NaN' ? '0 %' : earningPercentage(earning, expense) + ' %',
              style: TextStyle(fontSize: 13.0, color: Constants.primaryColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 10,
                  width: 10,
                  color: Colors.red.shade400,
                ),
                SizedBox(width: 20),
                Text(
                  'Expenditures',
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
            Text(
              expensePercentage(earning, expense) == 'NaN' ? '0 %' : expensePercentage(earning, expense) + ' %',
              style: TextStyle(fontSize: 13.0, color: Colors.red.shade400, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
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
                  HeaderWidget(headerText: compactCurrency(totalBalance), maxFontSize: 30, minFontSize: 28, textColor: Colors.white),
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
                  HeaderWidget(headerText: compactCurrency(totalBalance), maxFontSize: 30, minFontSize: 28, textColor: Colors.white),
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
    final _begin = _earning > _expense ? Alignment.center : Alignment.centerLeft;

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
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        HeaderWidget(headerText: compactCurrency(totalEarning), maxFontSize: 26, minFontSize: 23, textColor: Colors.white),
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
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        HeaderWidget(headerText: compactCurrency(totalExpense), maxFontSize: 26, minFontSize: 23, textColor: Colors.white),
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
        color: transactionType == Constants.DEBIT ? Colors.red.shade100 : Constants.lightGreen.withRed(210),
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
                  Container(
                    width: deviceWidth * 0.5,
                    child: AutoSizeText(
                      comment ?? '',
                      maxFontSize: 13,
                      minFontSize: 10,
                      maxLines: 2,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: deviceWidth * 0.19,
                child: AutoSizeText(
                  '₹ ' + compactCurrency(amount),
                  minFontSize: 9,
                  maxFontSize: 13,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: transactionType != Constants.CREDIT ? Colors.red.shade300 : Constants.primaryColor,
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

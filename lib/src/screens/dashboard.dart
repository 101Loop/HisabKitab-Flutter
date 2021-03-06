import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisabkitab/src/api_controller/api_controller.dart';
import 'package:hisabkitab/src/models/paginated_response.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/src/screens/add_transaction.dart';
import 'package:hisabkitab/src/screens/filter_screen.dart';
import 'package:hisabkitab/src/screens/main_screen.dart';
import 'package:hisabkitab/utils/app_localizations.dart';
import 'package:hisabkitab/utils/baked_icons/earning_icons.dart';
import 'package:hisabkitab/utils/baked_icons/spending_icons.dart';
import 'package:hisabkitab/utils/common_widgets/header_text.dart';
import 'package:hisabkitab/utils/common_widgets/non_animated_page_route.dart';
import 'package:hisabkitab/utils/common_widgets/sorting_items.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Returns compact version of the currency
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
  DashboardState createState() => DashboardState();
}

@visibleForTesting
class DashboardState extends State<Dashboard> with AutomaticKeepAliveClientMixin {
  /// Device's height and width
  double deviceHeight;
  double deviceWidth;

  /// App's state holder
  AppState provider;

  /// Future instance of the transaction details list
  Future<PaginatedResponse> _futureTransactionDetails;

  /// String representation of the transaction list API's query params
  String queryParams = '?';

  /// Next API URL to be called
  String _next;

  /// Is paginated items loading?
  bool _isLoadingItems = false;

  /// Is the transaction list fetched?
  bool _fetchedList = false;

  /// Instance of [AppLocalizations] to translate the words
  AppLocalizations appLocalizations;

  /// Called for the first time
  ///
  /// Initialize the variables here
  @override
  void initState() {
    super.initState();

    AppState initStateProvider = Provider.of<AppState>(context, listen: false);

    /// Only re-initialize the screen, if required
    if (initStateProvider.needsUpdate)

      /// Ensures that the build is done already
      WidgetsBinding.instance.addPostFrameCallback((_) {
        /// Sets the query params
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

        /// Gets and sets the credit and debit amount
        _futureTransactionDetails = APIController.getTransaction(queryParams);
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

    appLocalizations = AppLocalizations.of(context);
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
                              _refreshScreen();
                            },
                            color: Constants.lightGreen.withRed(210),
                            padding: EdgeInsets.all(0),
                            child: Text(
                              appLocalizations.translate('clearFilters'),
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
              key: ValueKey('transactionType'),
              headerText: provider.transactionType == Constants.CREDIT
                  ? appLocalizations.translate('earnings')
                  : provider.transactionType == Constants.DEBIT ? appLocalizations.translate('expenditures') : appLocalizations.translate('allTransactions'),
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
                        Text(appLocalizations.translate('pleaseWait')),
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

  /// Clears the filter option
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

  /// Displays a dialog for quick filter
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
                            appLocalizations.translate('earnings'),
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
                            appLocalizations.translate('expenditures'),
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
                            appLocalizations.translate('allTransactions'),
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
                            appLocalizations.translate('moreFilterOption'),
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
        key: ValueKey('transactionListview'),
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: provider.transactionList?.length,
        itemBuilder: (context, index) {
          TransactionDetails _currentTransaction = provider.transactionList?.elementAt(index);

          return GestureDetector(
            onTap: () {
              provider.setAutoValidate(false, willNotify: false);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => AddTransaction(transactionType: 'editTransaction', transaction: _currentTransaction),
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
                      title: Text(appLocalizations.translate('confirm')),
                      content: Text(appLocalizations.translate('areYouSure')),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            print(_currentTransaction.id);
                            print(_currentTransaction.amount);
                            APIController.deleteTransaction(_currentTransaction.id);
                            Navigator.of(context).pop(true);

                            provider.transactionList.removeAt(index);

                            _refreshScreen();
                          },
                          child: Text(appLocalizations.translate('delete')),
                        ),
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(appLocalizations.translate('cancel')),
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
    return Center(child: Text(appLocalizations.translate('nothingToShow')));
  }

  /// Sorts the transaction list and updates the UI
  ///
  /// [value] is a nullable field, make it null to sort it by the previous scheme, if there's no previous scheme
  void _sortTransactionList([SortingItems value]) {
    List<TransactionDetails> _tempList = List.from(provider.transactionList);

    /// If value is null or user selected the previously selected sort scheme
    /// Sort the list by name, and make the sorting items unselected
    if (value == null || provider.sortScheme == value.sortScheme) {
      provider.setSortScheme(-1, willNotify: false);
      provider.setTransactionList(provider.initialTransactionList);
      return;
    }

    _tempList = sortList(_tempList, value.sortScheme);
    provider.setSortScheme(value.sortScheme, willNotify: false);
    provider.setTransactionList(_tempList);
  }

  /// Returns the sorted list
  List<TransactionDetails> sortList(List<TransactionDetails> list, int sortScheme) {
    switch (sortScheme) {
      case 0:

        /// Name ascending
        list.sort((transaction1, transaction2) => transaction1.contact?.name?.compareTo(transaction2.contact?.name ?? ''));
        break;
      case 1:

        /// Name descending
        list.sort((transaction1, transaction2) => transaction2.contact?.name?.compareTo(transaction1.contact?.name ?? ''));
        break;
      case 2:

        /// Amount high to low
        list.sort((transaction1, transaction2) => transaction2.amount?.compareTo(transaction1.amount ?? 0));
        break;
      case 3:

        /// Amount low to high
        list.sort((transaction1, transaction2) => transaction1.amount?.compareTo(transaction2.amount ?? 0));
        break;
    }

    /// Returns the sorted list
    return list;
  }

  /// Loads more items on scrolling
  void _loadMore() {
    String next = !provider.needsUpdate ? provider.next : _next;

    if (next?.isNotEmpty ?? false) {
      List<TransactionDetails> _tempList = List.from(provider.transactionList);
      provider.setLoadingItems(true);
      APIController.getTransaction(queryParams, next: next).then(
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

  /// Returns, if the filter is applied or not
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

  /// Returns widget for sorting option
  List<PopupMenuEntry> _itemSortBuilder(BuildContext context) {
    return sortingItems
        .map((SortingItems val) => PopupMenuItem<SortingItems>(
            child: Text(
              AppLocalizations.of(context).translate(val.name),
              style: TextStyle(fontWeight: provider.sortScheme == val.sortScheme ? FontWeight.bold : FontWeight.normal),
            ),
            value: val))
        .toList();
  }

  /// Returns relevant widget in the center of the screen
  Widget _transactionListView() {
    return provider.isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Constants.primaryColor),
            ),
          )
        : provider.transactionList != null && provider.transactionList.length > 0 ? _listViewBuilder() : _nothingToShowWidget();
  }

  /// Navigates the user to the same screen to update the views
  void _refreshScreen() {
    provider.setNeedsUpdate(true, willNotify: false);
    Navigator.of(context).pushReplacement(NonAnimatedPageRoute(builder: (BuildContext context) => MainScreen()));
  }

  /// Sets the type of transaction, clears the filter and refreshes the screen with new values
  void _handleQuickFilterPressed(String transactionType) {
    Navigator.of(context).pop();
    provider.setTransactionType(transactionType, willNotify: false);
    _clearFilter();
    _refreshScreen();
  }
}

/// Stateless widget for [DataAnnotation]
///
/// Represents the [earning] and [expense] in percentage
class DataAnnotation extends StatelessWidget {
  DataAnnotation({Key key, @required this.earning, @required this.expense}) : super(key: key);

  /// Total earning and expense amount
  final String earning;
  final String expense;

  /// Returns earning percentage
  String earningPercentage(String earning, String expense) {
    double earningDouble = double.parse(earning);
    double expenseDouble = double.parse(expense);
    double percentage = (earningDouble / (earningDouble + expenseDouble)) * 100;
    return percentage.toStringAsFixed(2);
  }

  /// Returns expense percentage
  String expensePercentage(String earning, String expense) {
    double earningDouble = double.parse(earning);
    double expenseDouble = double.parse(expense);
    double percentage = (expenseDouble / (earningDouble + expenseDouble)) * 100;
    return percentage.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);

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
                  appLocalizations.translate('earnings'),
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
                  appLocalizations.translate('expenditures'),
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

/// Stateless widget for expenditure only
class RedCard extends StatelessWidget {
  RedCard({
    @required this.totalBalance,
    Key key,
  }) : super(key: key);

  /// Total amount to be shown
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

/// Stateless widget for both type of transactions
class RedGreenCard extends StatelessWidget {
  RedGreenCard({
    Key key,
    @required this.totalEarning,
    @required this.totalExpense,
  }) : super(key: key);

  /// Total earning and expense amount
  final String totalEarning;
  final totalExpense;

  @override
  Widget build(BuildContext context) {
    final double _earning = double.parse(totalEarning);
    final double _expense = double.parse(totalExpense);

    /// Calculates color portion to be shown according to the amount of earning and expenditure
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

/// Represents the transaction card
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

  /// Icon's data - the icon to be shown
  final IconData icon;

  /// Representational name of the transaction
  final String name;

  /// Amount of the transaction
  final String amount;

  /// Type of the transaction, either credit or debit
  final String transactionType;

  /// The date on which the transaction was made
  final String transactionDate;

  /// Some optional comments on the transaction
  final String comment;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);

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
                  transactionType == Constants.CREDIT ? appLocalizations.translate('credit') : appLocalizations.translate('debit'),
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

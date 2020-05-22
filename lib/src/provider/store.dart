import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/models/user_profile.dart';
import 'package:hisabkitab/src/screens/dashboard.dart';

/// Class to maintain app's state
///
/// Holds the state of the app and updates the listeners when they're notified
class AppState extends ChangeNotifier {
  /// Determines which sort scheme to apply
  int _sortScheme = -1;

  /// Represents current index of the tab, Ex: 0 for Dashboard
  int _currentTab = 0;

  /// Minimum and maximum amount, set in the filter option
  double _minAmountQuery = -1;
  double _maxAmountQuery = -1;

  /// Temporary min and max amount, used in case, the user discards these changes
  double _tempMinAmountQuery;
  double _tempMaxAmountQuery;

  /// Type of the transaction, either earnings or expenditures
  String _transactionType = 'Earnings';

  /// Credit and debit amount, used in Dashboard screen
  String _creditAmount = '0';
  String _debitAmount = '0';

  /// Selected mode of payment, Ex: cash, account transfer etc.
  String _mode;

  /// Selected category, either credit or debit
  String _category;

  /// Next API URL of paginated response
  String _next;

  /// Search and date query, used as the parameters in the transaction list API
  String _searchQuery = '';
  String _dateQuery = '';

  /// Temporary search and date query params, just in case these are discarded
  String _tempSearchQuery = '';
  String _tempDateQuery = '';

  /// Selected date
  String _dateTime = '';

  /// Temporarily selected date
  String _tempDateTime = '';

  /// Name's initials of the user
  String _initials = '?';

  /// Is OTP requested already?
  bool _otpRequested = false;

  /// Should a field be auto-validated?
  bool _autoValidate = false;

  /// Is the screen loading?
  bool _isLoading = false;

  /// Is the transaction's type earning, spending, both or none?
  bool _isEarning = false;
  bool _isSpending = false;

  /// Temporary versions of [_isEarning] and [_isSpending]
  bool _isTempEarning = false;
  bool _isTempSpending = false;

  /// Is the transaction's mode cash, card, cheque or account transfer?
  bool _isCashQuery = false;
  bool _isCardQuery = false;
  bool _isChequeQuery = false;
  bool _isAccountQuery = false;

  /// Temporary version of above variables
  bool _isTempCashQuery = false;
  bool _isTempCardQuery = false;
  bool _isTempChequeQuery = false;
  bool _isTempAccountQuery = false;

  /// Are the paginated items loading?
  bool _isLoadingItems = false;

  /// Is the add transaction clicked?
  bool _addTransactionClicked = false;

  /// Is the text hidden?
  bool _isHideText = true;

  /// Is the another text hidden?
  bool _isHideText1 = true;

  /// Is the current screen needs an update?
  bool _needsUpdate = true;

  /// Should the touches be ignored?
  bool _isIgnoring = false;

  /// List of [TransactionDetails], might be altered by the user, by sorting or filtering
  List<TransactionDetails> _transactionList = List();

  /// List of [TransactionDetails], without filter and sorting
  List<TransactionDetails> _initialTransactionList = List();

  /// Instance of [UserProfile], representing the details of the user
  UserProfile _userProfile;

  /// Currently selected page
  Widget _currentPage = Dashboard();

  /// getters
  int get sortScheme => _sortScheme;

  bool get getOTPRequested => _otpRequested;

  String get transactionType => _transactionType;

  String get creditAmount => _creditAmount;

  String get next => _next;

  bool get isLoading => _isLoading;

  bool get needsUpdate => _needsUpdate;

  String get debitAmount => _debitAmount;

  bool get autoValidate => _autoValidate;

  String get mode => _mode;

  String get category => _category;

  bool get isEarning => _isEarning;

  bool get isSpending => _isSpending;

  bool get isTempEarning => _isTempEarning;

  bool get isTempSpending => _isTempSpending;

  String get searchQuery => _searchQuery;

  String get dateQuery => _dateQuery;

  double get minAmountQuery => _minAmountQuery;

  double get maxAmountQuery => _maxAmountQuery;

  bool get isCashQuery => _isCashQuery;

  bool get isCardQuery => _isCardQuery;

  bool get isChequeQuery => _isChequeQuery;

  bool get isAccountQuery => _isAccountQuery;

  String get tempSearchQuery => _tempSearchQuery;

  String get tempDateQuery => _tempDateQuery;

  double get tempMinAmountQuery => _tempMinAmountQuery;

  double get tempMaxAmountQuery => _tempMaxAmountQuery;

  bool get isTempCashQuery => _isTempCashQuery;

  bool get isTempCardQuery => _isTempCardQuery;

  bool get isTempChequeQuery => _isTempChequeQuery;

  bool get isTempAccountQuery => _isTempAccountQuery;

  bool get isLoadingItems => _isLoadingItems;

  bool get addTransactionClicked => _addTransactionClicked;

  bool get isHideText => _isHideText;

  bool get isHideText1 => _isHideText1;

  bool get isIgnoring => _isIgnoring;

  int get currentTab => _currentTab;

  Widget get currentPage => _currentPage;

  String get dateTime => _dateTime;

  String get tempDateTime => _tempDateTime;

  String get initials => _initials;

  UserProfile get userProfile => _userProfile;

  List<TransactionDetails> get transactionList => _transactionList;

  List<TransactionDetails> get initialTransactionList => _initialTransactionList;


  /// setters
  setLoading(bool value, {bool willNotify = true}) {
    _isLoading = value;
    if (willNotify) notifyListeners();
  }

  setIgnoring(bool value, {bool willNotify = true}) {
    _isIgnoring = value;
    if (willNotify) notifyListeners();
  }

  setOTPRequested(bool value, {bool willNotify = true}) {
    _otpRequested = value;
    if (willNotify) notifyListeners();
  }

  setTransactionType(String value, {bool willNotify = true}) {
    _transactionType = value;
    if (willNotify) notifyListeners();
  }

  setAutoValidate(bool value, {bool willNotify = true}) {
    _autoValidate = value;
    if (willNotify) notifyListeners();
  }

  setCreditAmount(String creditAmount, {bool willNotify = true}) {
    _creditAmount = creditAmount;
    if (willNotify) notifyListeners();
  }

  setDebitAmount(String debitAmount, {bool willNotify = true}) {
    _debitAmount = debitAmount;
    if (willNotify) notifyListeners();
  }

  setMode(String mode, {bool willNotify = true}) {
    _mode = mode;
    if (willNotify) notifyListeners();
  }

  setCategory(String category, {bool willNotify = true}) {
    _category = category;
    if (willNotify) notifyListeners();
  }

  setEarning(bool isEarning, {bool willNotify = true}) {
    _isEarning = isEarning;
    if (willNotify) notifyListeners();
  }

  setTempEarning(bool isEarning, {bool willNotify = true}) {
    _isTempEarning = isEarning;
    if (willNotify) notifyListeners();
  }

  setTempSending(bool isSpending, {bool willNotify = true}) {
    _isTempSpending = isSpending;
    if (willNotify) notifyListeners();
  }

  setSpending(bool isSpending, {bool willNotify = true}) {
    _isSpending = isSpending;
    if (willNotify) notifyListeners();
  }

  setTempSpending(bool isSpending, {bool willNotify = true}) {
    _isTempSpending = isSpending;
    if (willNotify) notifyListeners();
  }

  setSearchQuery(String query, {bool willNotify = true}) {
    _searchQuery = query;
    if (willNotify) notifyListeners();
  }

  setTempSearchQuery(String query, {bool willNotify = true}) {
    _tempSearchQuery = query;
    if (willNotify) notifyListeners();
  }

  setDateQuery(String date, {bool willNotify = true}) {
    _dateQuery = date;
    if (willNotify) notifyListeners();
  }

  setMinAmountQuery(double amount, {bool willNotify = true}) {
    _minAmountQuery = amount;
    if (willNotify) notifyListeners();
  }

  setMaxAmountQuery(double amount, {bool willNotify = true}) {
    _maxAmountQuery = amount;
    if (willNotify) notifyListeners();
  }

  setCashQuery(bool cashQuery, {bool willNotify = true}) {
    _isCashQuery = cashQuery;
    if (willNotify) notifyListeners();
  }

  setCardQuery(bool cardQuery, {bool willNotify = true}) {
    _isCardQuery = cardQuery;
    if (willNotify) notifyListeners();
  }

  setChequeQuery(bool chequeQuery, {bool willNotify = true}) {
    _isChequeQuery = chequeQuery;
    if (willNotify) notifyListeners();
  }

  setAccountQuery(bool accountQuery, {bool willNotify = true}) {
    _isAccountQuery = accountQuery;
    if (willNotify) notifyListeners();
  }

  setTempDateQuery(String date, {bool willNotify = true}) {
    _tempDateQuery = date;
    if (willNotify) notifyListeners();
  }

  setTempMinAmountQuery(double amount, {bool willNotify = true}) {
    _tempMinAmountQuery = amount;
    if (willNotify) notifyListeners();
  }

  setTempMaxAmountQuery(double amount, {bool willNotify = true}) {
    _tempMaxAmountQuery = amount;
    if (willNotify) notifyListeners();
  }

  setTempCashQuery(bool cashQuery, {bool willNotify = true}) {
    _isTempCashQuery = cashQuery;
    if (willNotify) notifyListeners();
  }

  setTempCardQuery(bool cardQuery, {bool willNotify = true}) {
    _isTempCardQuery = cardQuery;
    if (willNotify) notifyListeners();
  }

  setTempChequeQuery(bool chequeQuery, {bool willNotify = true}) {
    _isTempChequeQuery = chequeQuery;
    if (willNotify) notifyListeners();
  }

  setTempAccountQuery(bool accountQuery, {bool willNotify = true}) {
    _isTempAccountQuery = accountQuery;
    if (willNotify) notifyListeners();
  }

  setTransactionList(List<TransactionDetails> list, {bool willNotify = true}) {
    _transactionList = list;
    if (willNotify) notifyListeners();
  }

  setInitialTransactionList(List<TransactionDetails> list, {bool willNotify = true}) {
    _initialTransactionList = list;
    if (willNotify) notifyListeners();
  }

  updateTransactionList(List<TransactionDetails> list, {bool willNotify = true}) {
    _transactionList.addAll(list);
    if (willNotify) notifyListeners();
  }

  setLoadingItems(bool isLoadingItems, {bool willNotify = true}) {
    _isLoadingItems = isLoadingItems;
    if (willNotify) notifyListeners();
  }

  setUserProfile(UserProfile userProfile, {bool willNotify = true}) {
    _userProfile = userProfile;
    if (willNotify) notifyListeners();
  }

  setInitials(String initials, {bool willNotify = true}) {
    _initials = initials;
    if (willNotify) notifyListeners();
  }

  setTransactionClicked(bool transactionClicked, {bool willNotify = true}) {
    _addTransactionClicked = transactionClicked;
    if (willNotify) notifyListeners();
  }

  setCurrentTab(int currentTab, {bool willNotify = true}) {
    _currentTab = currentTab;
    if (willNotify) notifyListeners();
  }

  setDateTime(String dateTime, {bool willNotify = true}) {
    _dateTime = dateTime;
    if (willNotify) notifyListeners();
  }

  setTempDateTime(String dateTime, {bool willNotify = true}) {
    _tempDateTime = dateTime;
    if (willNotify) notifyListeners();
  }

  setHideText(bool isHideText, {bool willNotify = true}) {
    _isHideText = isHideText;
    if (willNotify) notifyListeners();
  }

  setHideText1(bool isHideText, {bool willNotify = true}) {
    _isHideText1 = isHideText;
    if (willNotify) notifyListeners();
  }

  setCurrentPage(Widget currentPage, {bool willNotify = true}) {
    _currentPage = currentPage;
    if (willNotify) notifyListeners();
  }

  setSortScheme(int sortSceme, {bool willNotify = true}) {
    _sortScheme = sortSceme;
    if (willNotify) notifyListeners();
  }

  setNeedsUpdate(bool needsUpdate, {bool willNotify = true}) {
    _needsUpdate = needsUpdate;
    if (willNotify) notifyListeners();
  }

  setNext(String next, {bool willNotify = true}) {
    _next = next;
    if (willNotify) notifyListeners();
  }

  /// defaults all the value
  void clearData() {
    _sortScheme = -1;
    _needsUpdate = true;
    _next = null;
    _creditAmount = '0';
    _debitAmount = '0';
    _mode = null;
    _category = null;
    _tempSearchQuery = '';
    _tempDateQuery = '';
    _transactionType = 'Earnings';
    _dateTime = '';
    _searchQuery = '';
    _dateQuery = '';
    _initials = '?';

    _minAmountQuery = -1;
    _maxAmountQuery = -1;

    _currentTab = 0;

    _isLoading = false;
    _otpRequested = false;
    _autoValidate = false;
    _isEarning = false;
    _isSpending = false;
    _isTempEarning = false;
    _isTempSpending = false;
    _isCashQuery = false;
    _isCardQuery = false;
    _isChequeQuery = false;
    _isAccountQuery = false;
    _isTempCashQuery = false;
    _isTempCardQuery = false;
    _isTempChequeQuery = false;
    _isTempAccountQuery = false;
    _isLoadingItems = false;
    _addTransactionClicked = false;
    _isHideText = true;
    _isHideText1 = true;

    _transactionList = List();

    _userProfile = null;
  }
}

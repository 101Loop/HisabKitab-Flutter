import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/models/user_profile.dart';
import 'package:hisabkitab/src/screens/dashboard.dart';

class AppState extends ChangeNotifier {
  bool _otpRequested = false;
  String _transactionType = 'Earnings';
  bool _autoValidate = false;
  bool _isLoading = false;
  String _creditAmount = '0';
  String _debitAmount = '0';
  String _mode;
  String _category;
  bool _isEarning = false;
  bool _isSpending = false;
  bool _isTempEarning = false;
  bool _isTempSpending = false;
  String _searchQuery = '';
  String _dateQuery = '';
  double _minAmountQuery = -1;
  double _maxAmountQuery = -1;
  bool _isCashQuery = false;
  bool _isCardQuery = false;
  bool _isChequeQuery = false;
  bool _isAccountQuery = false;
  String _tempSearchQuery = '';
  String _tempDateQuery = '';
  double _tempMinAmountQuery;
  double _tempMaxAmountQuery;
  bool _isTempCashQuery = false;
  bool _isTempCardQuery = false;
  bool _isTempChequeQuery = false;
  bool _isTempAccountQuery = false;
  bool _isLoadingItems = false;
  bool _addTransactionClicked = false;
  bool _isHideText = true;
  bool _isHideText1 = true;
  int _currentTab = 0;
  String _dateTime = '';
  String _tempDateTime = '';
  UserProfile _userProfile;
  List<TransactionDetails> _transactionList = List();
  String _initials = '?';
  Widget _currentPage = Dashboard();

  bool _isIgnoring = false;

  bool get getOTPRequested => _otpRequested;

  String get transactionType => _transactionType;

  String get creditAmount => _creditAmount;

  bool get isLoading => _isLoading;

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

  updateTransactionList(List<TransactionDetails> list,
      {bool willNotify = true}) {
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

  void initialState() {
    _autoValidate = false;
  }

  void clearData() {
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

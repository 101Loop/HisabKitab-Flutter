import 'package:flutter/foundation.dart';
import 'package:hisabkitab/src/models/transaction.dart';
import 'package:hisabkitab/src/models/user_profile.dart';

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
  String _searchQuery = '';
  String _dateQuery = '';
  double _minAmountQuery = -1;
  double _maxAmountQuery = -1;
  bool _isCashQuery = false;
  bool _isCardQuery = false;
  bool _isChequeQuery = false;
  bool _isAccountQuery = false;
  bool _isLoadingItems = false;
  UserProfile _userProfile;
  List<TransactionDetails> _transactionList = List();

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
  String get searchQuery => _searchQuery;
  String get dateQuery => _dateQuery;
  double get minAmountQuery => _minAmountQuery;
  double get maxAmountQuery => _maxAmountQuery;
  bool get isCashQuery => _isCashQuery;
  bool get isCardQuery => _isCardQuery;
  bool get isChequeQuery => _isChequeQuery;
  bool get isAccountQuery => _isAccountQuery;
  bool get isLoadingItems => _isLoadingItems;
  UserProfile get userProfile => _userProfile;
  List<TransactionDetails> get transactionList => _transactionList;

  setLoading(bool value, {bool willNotify = true}) {
    _isLoading = value;
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

  setSpending(bool isSpending, {bool willNotify = true}) {
    _isSpending = isSpending;
    if (willNotify) notifyListeners();
  }

  setSearchQuery(String query, {bool willNotify = true}) {
    _searchQuery = query;
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
    _isCardQuery =cardQuery;
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

  setTransactionList(List<TransactionDetails> list, {bool willNotify = true}) {
    _transactionList = list;
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

  void initialState() {
    _autoValidate = false;
  }
}

import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  bool _otpRequested = false;
  String _transactionType = 'Earnings';
  bool _autoValidate = false;
  bool _isLoading = false;
  String _creditAmount = '0';
  String _debitAmount = '0';
  String _mode;

  bool get getOTPRequested => _otpRequested;

  String get transactionType => _transactionType;

  bool get autoValidate => _autoValidate;

  bool get isLoading => _isLoading;

  String get creditAmount => _creditAmount;
  String get debitAmount => _debitAmount;

  String get mode => _mode;

  setIsLoading(bool value, {bool willNotify = true}) {
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

  void initialState() {
    _autoValidate = false;
  }
}

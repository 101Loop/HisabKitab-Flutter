import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  bool _otpRequested = false;
  String _transactionType = 'Earnings';
  bool _autoValidate = false;

  bool get getOTPRequested => _otpRequested;
  String get getTransactionType => _transactionType;
  bool get getAutoValidate => _autoValidate;

  setOTPRequested(bool value, {bool willNotify = false}) {
    _otpRequested = value;
    if (willNotify) notifyListeners();
  }

  setTransactionType(String value, {bool willNotify = false}) {
    _transactionType = value;
    if (willNotify) notifyListeners();
  }

  setAutoValidate(bool value, {bool willNotify = false}) {
    _autoValidate = value;
    if (willNotify) notifyListeners();
  }

  void initalState() {
    _autoValidate = false;
  }
}

import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  bool _otpRequested = false;
  String _popUpMenuItem = 'Latest';
  String _transactionType = 'earnings';
  double _cardHeight;

  bool get getOTPRequested => _otpRequested;
  String get getPopMenuItem => _popUpMenuItem;
  String get getTransactionType => _transactionType;
  double get getCardHeight => _cardHeight;

  setOTPRequested(bool value, {bool willNotify = false}) {
    _otpRequested = value;
    if (willNotify) notifyListeners();
  }

  setPopMenuItem(String value, {bool willNotify = false}) {
    _popUpMenuItem = value;
    if (willNotify) notifyListeners();
  }

  setTransactionType(String value, {bool willNotify = false}) {
    _transactionType = value;
    if (willNotify) notifyListeners();
  }

  setCardHeight(double value, {bool willNotify = false}) {
    _cardHeight = value;
    if (willNotify) notifyListeners();
  }
}

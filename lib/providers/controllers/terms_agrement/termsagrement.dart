import 'package:flutter/material.dart';

class Termsagrement extends ChangeNotifier {
  bool _isAgreed = false;

  bool get isAgreed => _isAgreed;

  void setAgreement(bool value) {
    _isAgreed = value;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Validation extends ChangeNotifier {
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'PK');
  bool _isValid = false;
  String? _errorText;

  PhoneNumber get phoneNumber => _phoneNumber;
  bool get isValid => _isValid;
  String? get errorText => _errorText;

  void onPhoneNumberChanged(PhoneNumber number) {
    _phoneNumber = number;
    notifyListeners();
  }

  void onPhoneNumberValidated(bool value) {
    _isValid = value;
    _errorText = _isValid ? null : "Invalid phone number";
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class PhoneAuthProvider with ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  String _verificationId = '';
  bool _isLoading = false;
  String? _errorMessage;
  String get verificationId => _verificationId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> sendOTP(String phoneNumber) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (
        firebase_auth.PhoneAuthCredential credential,
      ) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (firebase_auth.FirebaseAuthException e) {
        _errorMessage = e.message;
        _isLoading = false;
        notifyListeners();
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _isLoading = false;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      firebase_auth.PhoneAuthCredential credential = firebase_auth
          .PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = "Invalid OTP. Please try again.";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

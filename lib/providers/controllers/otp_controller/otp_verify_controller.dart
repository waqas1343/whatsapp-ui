import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;
  bool isLoading = false;
  String? errorMessage;

  void setVerificationId(String verId) {
    verificationId = verId;
    notifyListeners();
  }

  Future<bool> verifyOTP(String otp) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = "Invalid OTP, please try again.";
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

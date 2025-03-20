import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medichat/core/utils/custom_button/custom_button.dart';
import 'package:medichat/screens/home/whatsapp_dashboard_screen/dashboard_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import 'package:provider/provider.dart';


class OtpScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();
  final String verficationId; // Fix: Correct spelling

  OtpScreen({super.key, required this.verficationId});

  final defaultPinTheme = PinTheme(
    width: 14.w,
    height: 10.h,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final apptextTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Enter OTP Code"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Code has been sent to your email.",
                style: apptextTheme.bodyLarge,
              ),
              SizedBox(height: 8.h),
              Pinput(
                controller: otpController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              CustomButton(

                text: otpController.isLoading ? "Verifying..." : "Verify",
                onPressed:
                    otpController.isLoading
                        ? null
                        : () async {
                          bool isVerified = await otpController.verifyOTP("");
                          if (isVerified) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashboardScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },

                // text: "Verify",
                // onPressed: () {
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(builder: (context) => DashboardScreen()),
                //   );
                // },

                text: 'Verify',
                onPressed: () async {
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                          verificationId:
                              verficationId, // Fix: Directly use verficationId
                          smsCode: otpController.text.trim(),
                        );

                    // Sign in the user
                    await FirebaseAuth.instance.signInWithCredential(
                      credential,
                    );

                    // Navigate to Dashboard
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(),
                      ),
                    );
                  } catch (ex) {
                    print("Error: $ex");
                  }
                },

              ),
            ],
          ),
        ),
      ),
    );
  }
}

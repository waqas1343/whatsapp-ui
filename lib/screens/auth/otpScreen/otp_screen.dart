import 'package:flutter/material.dart';
import 'package:medichat/core/utils/custom_button/custom_button.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

class OtpScreen extends StatelessWidget {
  final defaultPinTheme = PinTheme(
    width: 14.w,
    height: 10.h,
    textStyle: TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apptextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text("Enter OTP Code"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Code has been to +92 11*******54",
                style: apptextTheme.bodyLarge,
              ),
              SizedBox(height: 8.h),
              Pinput(
                length: 4,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              RichText(
                text: TextSpan(
                  style: apptextTheme.headlineSmall,
                  children: [
                    TextSpan(text: "Resend Code in "),
                    TextSpan(
                      text: "56",
                      style: apptextTheme.headlineSmall?.copyWith(
                        color: Colors.lightGreen,
                      ),
                    ),
                    TextSpan(text: " s", style: apptextTheme.headlineSmall),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              CustomButton(text: "Verify", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

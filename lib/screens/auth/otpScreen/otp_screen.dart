import 'package:flutter/material.dart';
import 'package:medichat/core/utils/custom_button/custom_button.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/customOtpScreen/custom_otp.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
              CustomOtp(keyboardtype: TextInputType.number),
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

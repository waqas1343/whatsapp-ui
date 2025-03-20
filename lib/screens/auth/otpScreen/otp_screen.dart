import 'package:flutter/material.dart';
import 'package:medichat/core/utils/custom_button/custom_button.dart';
import 'package:medichat/providers/controllers/otp_controller/otp_verify_controller.dart';
import 'package:medichat/screens/home/whatsapp_dashboard_screen/dashboard_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;

  OtpScreen({super.key, required this.phoneNumber});

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

  String getMaskedPhoneNumber() {
    if (phoneNumber.length > 5) {
      return "${phoneNumber.substring(0, 6)}*****${phoneNumber.substring(phoneNumber.length - 3)}";
    }
    return phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    final apptextTheme = Theme.of(context).textTheme;
    final otpController = Provider.of<OtpController>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Enter OTP Code"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Code has been sent to ${getMaskedPhoneNumber()}",
                style: apptextTheme.bodyLarge,
              ),
              SizedBox(height: 8.h),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onCompleted: (otp) {
                  otpController.verifyOTP(otp);
                },
              ),
              if (otpController.errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    otpController.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 8.h),
              RichText(
                text: TextSpan(
                  style: apptextTheme.titleMedium,
                  children: [
                    TextSpan(text: "Resend Code in "),
                    TextSpan(
                      text: "56",
                      style: apptextTheme.headlineSmall?.copyWith(
                        color: Colors.lightGreen,
                      ),
                    ),
                    TextSpan(text: " s", style: apptextTheme.titleMedium),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/color_utils/app_colors.dart';
import '../../../core/utils/custom_button/custom_button.dart';
import '../../../providers/controllers/image_picker/image_pickerController.dart';
import '../../home/whatsapp_dashboard_screen/dashboard_screen.dart';

class OtpScreen extends StatelessWidget {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: AppColors.blackTextClr,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  final String phoneNumber;

  OtpScreen({super.key, required this.phoneNumber}) {
    otpController.text = "1234";
  }

  void verifyOtp(BuildContext context) {
    if (otpController.text.trim() == '1234') {
      Provider.of<ProfileProvider>(context, listen: false).setPhoneNumber(phoneNumber);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP, please try again")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter OTP Code"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter 4-digit OTP",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Pinput(
              //   controller: otpController,
              //   focusNode: otpFocusNode,
              //   length: 4,
              //   defaultPinTheme: PinTheme(
              //     width: 56,
              //     height: 56,
              //     textStyle: const TextStyle(
              //       fontSize: 22,
              //       fontWeight: FontWeight.bold,
              //     ),
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.blue),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   onTap: () {
              //     if (otpController.text.isEmpty) {
              //       otpController.text = "1234";
              //     }
              //   },
              // ),
              Pinput(
                controller: otpController,
                length: 4,
                defaultPinTheme: defaultPinTheme,
                showCursor: true,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onTap: () {
                  if (otpController.text.isEmpty) {
                    otpController.text = "1234";
                  }
                },
              ),
              const SizedBox(height: 30),
              CustomButton(text: 'Verify', onPressed: () => verifyOtp(context)),
            ],
          ),
        ),
      ),
    );
  }
}

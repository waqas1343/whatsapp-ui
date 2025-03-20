import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:medichat/core/constant/custom_text_field/custom_textfield.dart';
import 'package:medichat/screens/auth/otpScreen/otp_screen.dart';
import 'package:provider/provider.dart';
import 'package:medichat/providers/controllers/validation/validation.dart';
import 'package:medichat/core/constant/custom_text/custom_text.dart';
import 'package:medichat/core/utils/color_utils/app_colors.dart';
import 'package:medichat/core/utils/custom_button/custom_button.dart';

class PhoneNumberScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apptextTheme = Theme.of(context).textTheme;
    final phoneProvider = Provider.of<Validation>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Enter your phone number',
                    style: apptextTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    CustomText(
                      text: "We will need to verify your phone number.",
                      style: apptextTheme.labelSmall,
                    ),
                    CustomText(
                      text: "What's my number?",
                      style: apptextTheme.titleSmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomTextField(
                  controller: phoneController,
                  hintText: 'enter phone number',
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: CustomText(
                  text: 'Carrier charges may apply',
                  style: apptextTheme.titleSmall,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 120.0),
                child: CustomButton(
                  text: 'NEXT',
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException ex) {
                        print("Verification Failed: ${ex.message}");
                      },
                      codeSent: (String verificationId, int? resendtoken) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(verficationId: ''),
                          ),
                        );
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                      phoneNumber: phoneController.text.toString(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

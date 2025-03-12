import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:medichat/core/constant/custom_text/custom_text.dart';
import 'package:medichat/core/utils/color_utils/app_colors.dart';
import 'package:medichat/core/utils/custom_button/custom_button.dart';
import 'package:medichat/screens/auth/otpScreen/otp_screen.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apptextTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),

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

              SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    CustomText(
                      text: "WhatsApp will need to verify your phone number.",
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

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: InternationalPhoneNumberInput(
                  onInputChanged: (value) {},
                  selectorConfig: SelectorConfig(
                    leadingPadding: 10,
                    showFlags: true,
                    trailingSpace: false,
                    useBottomSheetSafeArea: true,
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    setSelectorButtonAsPrefixIcon: false,
                  ),
                  initialValue: PhoneNumber(),
                  ignoreBlank: true,
                  textStyle: apptextTheme.bodyLarge,
                  inputDecoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    hintText: "347 580 5904",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: AppColors.textColorGrey,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textColorGrey,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textColorGrey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.appColorG,
                        width: 2,
                      ),
                    ),
                  ),
                  selectorTextStyle: apptextTheme.bodyLarge,
                ),
              ),

              SizedBox(height: 15),

              Center(
                child: CustomText(
                  text: 'Carrier charges may apply',
                  style: apptextTheme.titleSmall,
                ),
              ),
              Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 120.0),
                child: CustomButton(
                  text: 'NEXT',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => OtpScreen()),
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

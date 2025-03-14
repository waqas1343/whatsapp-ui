import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:medichat/providers/controllers/phone_verification_controller/phone_verification_controller.dart';
import 'package:provider/provider.dart';
import 'package:medichat/providers/controllers/validation/validation.dart';
import 'package:medichat/screens/auth/otpScreen/otp_screen.dart';
import 'package:medichat/core/constant/custom_text/custom_text.dart';
import 'package:medichat/core/utils/color_utils/app_colors.dart';
import 'package:medichat/core/utils/custom_button/custom_button.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apptextTheme = Theme.of(context).textTheme;
    final phoneProvider = Provider.of<Validation>(context);
    final phoneAuthProvider = Provider.of<PhoneAuthProvider>(context);

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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: InternationalPhoneNumberInput(
                  onInputChanged: (number) {
                    phoneProvider.onPhoneNumberChanged(number);
                  },
                  onInputValidated: phoneProvider.onPhoneNumberValidated,
                  selectorConfig: const SelectorConfig(
                    leadingPadding: 10,
                    showFlags: true,
                    trailingSpace: false,
                    useBottomSheetSafeArea: true,
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    setSelectorButtonAsPrefixIcon: false,
                  ),
                  initialValue: phoneProvider.phoneNumber,
                  ignoreBlank: true,
                  textStyle: apptextTheme.bodyLarge,
                  inputDecoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    hintText: "347 580 5904",
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textColorGrey,
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textColorGrey,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textColorGrey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.appColorG,
                        width: 2,
                      ),
                    ),
                    errorText: phoneProvider.errorText,
                  ),
                  selectorTextStyle: apptextTheme.bodyLarge,
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
                  onPressed:
                      phoneProvider.isValid
                          ? () {
                            phoneAuthProvider.sendOTP(
                              phoneProvider.phoneNumber.phoneNumber ?? '',
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtpScreen(phoneNumber: '',),
                              ),
                              (route) => false,
                            );
                          }
                          : () {
                            print(
                              'Button Disabled, isValid: ${phoneProvider.isValid}',
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

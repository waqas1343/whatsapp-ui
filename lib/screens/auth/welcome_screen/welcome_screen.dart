import 'package:flutter/material.dart';
import 'package:medichat/core/utils/app_images/app_images.dart';
import 'package:medichat/core/utils/color_utils/app_colors.dart';
import 'package:medichat/core/utils/custom_button/custom_button.dart';
import 'package:medichat/screens/auth/phone_number_screen/phone_number_screen.dart';
import 'package:sizer/sizer.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apptextTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome to WhatsApp", style: apptextTheme.headlineMedium),
              SizedBox(height: 6.h),

              ClipOval(
                child: Image.asset(
                  AppImages.welcome,
                  width: 70.w,
                  height: 35.h,
                  fit: BoxFit.fill,
                ),
              ),

              SizedBox(height: 6.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: apptextTheme.labelSmall,
                    children: [
                      TextSpan(
                        text: "Read our ",
                        style: apptextTheme.titleSmall?.copyWith(
                          color: AppColors.textColorGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: apptextTheme.titleSmall?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ". Tap \"Agree and continue\" to accept the ",
                        style: apptextTheme.titleSmall?.copyWith(
                          color: AppColors.textColorGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "Terms of Service.",
                        style: apptextTheme.titleSmall?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 6.h),

              CustomButton(
                text: 'AGREE AND CONTINUE',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhoneNumberScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

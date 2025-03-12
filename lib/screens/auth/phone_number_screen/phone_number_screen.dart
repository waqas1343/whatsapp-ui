import 'package:flutter/material.dart';
import 'package:medichat/core/constant/custom_text/custom_text.dart';
import 'package:medichat/core/utils/color_utils/app_colors.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apptextTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Enter your phone number',
                    style: apptextTheme.bodyLarge,
                  ),
                  SizedBox(width: 20),
                  IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
                ],
              ),
              RichText(
                selectionColor: AppColors.blackTextClr,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: AppColors.blackTextClr),
                  children: [
                    TextSpan(
                      text: "WhatsApp will need to verify your phone number.",
                      style: apptextTheme.titleSmall,
                    ),
                    TextSpan(
                      text: "What’s  my number?",
                      style: apptextTheme.titleSmall?.copyWith(
                        color: AppColors.blackTextClr,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

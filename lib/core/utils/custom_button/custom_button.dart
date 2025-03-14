import 'package:flutter/material.dart';
import 'package:medichat/core/utils/color_utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // ✅ Nullable banaya
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double height;
  final double width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed, // ✅ Nullable
    this.color = AppColors.appColorG,
    this.textColor = Colors.black,
    this.borderRadius = 8.0,
    this.height = 45,
    this.width = 300,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed != null ? () => onPressed!() : null, // ✅ Null check
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: onPressed != null ? color : Colors.grey, // ✅ Disabled color
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

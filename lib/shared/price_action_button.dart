import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

class PriceActionButton extends StatelessWidget {
  const PriceActionButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.buttonWidth,
  });
  final String buttonText;
  final Function() onTap;
  final double? buttonWidth;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          child: CustomText(
            text: buttonText,
            color: AppColors.whiteColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

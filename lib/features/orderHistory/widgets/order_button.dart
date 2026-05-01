import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

class OrderActionButton extends StatelessWidget {
  const OrderActionButton({
    super.key,
    required this.onTap,
    required this.buttonText,
  });
  final Function() onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: CustomText(
          text: buttonText,
          color: AppColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

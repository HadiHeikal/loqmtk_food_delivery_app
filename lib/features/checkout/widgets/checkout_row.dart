import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

class CheckoutRow extends StatelessWidget {
  const CheckoutRow({
    super.key,
    required this.text,
    required this.price,
    this.color,
    this.fontWeight,
  });
  final String text;
  final String price;
  final Color? color;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: text,
            fontSize: 16,
            fontWeight: fontWeight ?? FontWeight.normal,
            color: color ?? AppColors.blackColor.withValues(alpha: .5),
          ),
          CustomText(
            text: price,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.blackColor.withValues(alpha: .5),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';
import 'package:loqmtk_food_delivery_app/shared/price_action_button.dart';

class PriceActionSection extends StatelessWidget {
  const PriceActionSection({
    super.key,
    required this.price,
    required this.onTap,
    required this.buttonText,
  });
  final String price;
  final Function() onTap;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Total',
              color: AppColors.blackColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            Gap(4),
            CustomText(
              text: '\$ $price',
              color: AppColors.primaryColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'ReemKufi',
            ),
          ],
        ),
        // custom button widget
        PriceActionButton(buttonText: buttonText, onTap: onTap),
      ],
    );
  }
}

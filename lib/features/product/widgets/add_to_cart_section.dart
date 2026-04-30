import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

class AddToCartSection extends StatelessWidget {
  const AddToCartSection({super.key, required this.price, required this.onTap});
  final String price;
  final Function() onTap;
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
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              child: CustomText(
                text: 'Add to Cart',
                color: AppColors.whiteColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

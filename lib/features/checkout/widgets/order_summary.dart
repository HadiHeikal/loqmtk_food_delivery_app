import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/features/checkout/widgets/checkout_row.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Order summary',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.blackColor,
        ),
        Gap(10),
        // order row
        CheckoutRow(text: 'Order', price: '\$150'),
        // Taxes row
        CheckoutRow(text: 'Taxes', price: '\$70'),
        // delivery fee row
        CheckoutRow(text: 'Delivery fee', price: '\$30'),
        const Divider(color: AppColors.greyColor, thickness: 1),
        Gap(20),
        //total row
        CheckoutRow(
          text: 'Total',
          price: '\$250',
          color: AppColors.blackColor,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

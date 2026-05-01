import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/features/orderHistory/widgets/order_button.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    required this.orderName,
    required this.orderImage,
    required this.orderQuantity,
    required this.orderPrice,
    required this.onOrderAgain,
  });
  final String orderName;
  final String orderImage;
  final int orderQuantity;
  final double orderPrice;
  final Function() onOrderAgain;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        child: Column(
          children: [
            Row(
              children: [
                // order image
                Image.asset(orderImage, height: 100, width: 100),
                Gap(60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // order name
                    CustomText(
                      text: orderName,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                    // order Quantity
                    CustomText(
                      text: 'Quantity: X$orderQuantity',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackColor,
                    ),
                    // order Price
                    CustomText(
                      text: 'Price: \$$orderPrice',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ],
            ),
            Gap(10),
            // order again button
            OrderActionButton(onTap: onOrderAgain, buttonText: 'Order Again'),
          ],
        ),
      ),
    );
  }
}

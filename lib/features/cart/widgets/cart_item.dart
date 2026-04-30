import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.itemName,
    required this.itemDescription,
    required this.itemImage,
    required this.onPlus,
    required this.onMinus,
    required this.onRemoveItem,
    required this.itemQuantity,
  });
  final String itemName;
  final String itemDescription;
  final String itemImage;
  final Function() onPlus;
  final Function() onMinus;
  final Function() onRemoveItem;
  final int itemQuantity;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        child: Row(
          children: [
            // item image
            Column(
              children: [
                Image.asset(itemImage, width: 100, height: 100),
                Gap(5),
                CustomText(
                  text: itemName,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                  fontSize: 20,
                ),
                CustomText(
                  text: itemDescription,
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            Gap(50),
            // item name and description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // plus and minus buttons
                Row(
                  children: [
                    GestureDetector(
                      onTap: onPlus,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(Icons.add, color: AppColors.whiteColor),
                      ),
                    ),
                    Gap(20),
                    CustomText(
                      text: itemQuantity.toString(),
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: AppColors.blackColor,
                    ),
                    Gap(20),
                    GestureDetector(
                      onTap: onMinus,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(Icons.remove, color: AppColors.whiteColor),
                      ),
                    ),
                  ],
                ),
                Gap(20),
                // remove item from cart button
                GestureDetector(
                  onTap: onRemoveItem,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      child: CustomText(
                        text: 'Remove item',
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

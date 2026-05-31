import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/features/product/data/product_model.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

class CustomItem extends StatelessWidget {
  const CustomItem({
    super.key,
    required this.productModel,
    required this.onAdd,
  });
  final ProductModel? productModel;
  final Function() onAdd;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 90,
          width: 130,
          decoration: BoxDecoration(
            color: AppColors.toppingsSectionBgColor,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Positioned(
          top: -40,
          left: -5,
          right: -5,
          child: SizedBox(
            height: 90,
            width: 120,
            child: Card(
              elevation: 10,
              shadowColor: AppColors.blackColor,
              color: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.network(productModel?.image ?? ''),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 15,
          left: 15,
          child: Row(
            children: [
              CustomText(
                text: productModel?.name ?? '',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              Spacer(),
              Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: AppColors.toppingsButtonBgColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onAdd,
                  icon: Icon(Icons.add, color: AppColors.whiteColor, size: 25),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

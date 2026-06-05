import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/features/product/data/product_model.dart';
import 'package:loqmtk_food_delivery_app/features/product/widgets/custom_item.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

class CustomSection extends StatelessWidget {
  const CustomSection({
    super.key,
    required this.sectionTitle,
    required this.productModel,
    required this.onAdd,
    required this.selectedIndices,
  });

  final String sectionTitle;
  final List<ProductModel>? productModel;
  final List<int> selectedIndices; // Holds currently selected indices
  final Function(int index)
  onAdd; // Modified signature to provide the relevant index upstream

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(20),
        CustomText(
          text: sectionTitle,
          color: AppColors.blackColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        Gap(40),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(productModel?.length ?? 4, (index) {
              final isSelected = selectedIndices.contains(index);
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CustomItem(
                  productModel: productModel?[index],
                  onAdd: onAdd,
                  isSelected: isSelected,
                  index: index,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

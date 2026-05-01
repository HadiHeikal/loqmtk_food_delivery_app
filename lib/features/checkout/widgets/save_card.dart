import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

class SaveCard extends StatelessWidget {
  const SaveCard({super.key, required this.saveCard, required this.onChanged});
  final bool saveCard;
  final Function(bool?) onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: saveCard,
          onChanged: onChanged,
          checkColor: AppColors.whiteColor,
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            return saveCard ? AppColors.primaryColor : AppColors.whiteColor;
          }),
          side: BorderSide(color: AppColors.primaryColor, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
        CustomText(
          text: 'Save card details for future payments',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.blackColor,
        ),
      ],
    );
  }
}

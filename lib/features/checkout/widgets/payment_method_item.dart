import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

class PaymentMethodItem extends StatelessWidget {
  const PaymentMethodItem({
    super.key,
    required this.title,
    required this.image,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.selectedColor,
    this.cardNumber,
  });
  final String title;
  final String? cardNumber;
  final String image;
  final String value;
  final String groupValue;
  final Color? selectedColor;
  final Function(String?) onChanged;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () => onChanged(value),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.greyColor, width: 1),
      ),
      hoverColor: AppColors.whiteColor,
      selectedTileColor: selectedColor,
      selected: true,
      leading: Image.asset(image, width: 60, height: 60),
      title: CustomText(
        text: title,
        fontSize: 18,
        color: AppColors.whiteColor,
        fontWeight: FontWeight.bold,
      ),
      subtitle: cardNumber != null
          ? CustomText(
              text: cardNumber!,
              fontSize: 16,
              color: AppColors.whiteColor,
            )
          : CustomText(
              text: 'safe payment method',
              fontSize: 16,
              color: AppColors.whiteColor,
            ),
      trailing: RadioGroup(
        groupValue: groupValue,
        onChanged: onChanged,
        child: Radio(
          value: value,
          fillColor: WidgetStatePropertyAll(AppColors.whiteColor),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

class SpicySlider extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;
  const SpicySlider({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<SpicySlider> createState() => _SpicySliderState();
}

class _SpicySliderState extends State<SpicySlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: Image.asset(
            'assets/images/details/burger_items.png',
            height: 240,
          ),
        ),
        Column(
          children: [
            Gap(50),
            Row(
              children: [
                CustomText(
                  text: 'Customize ',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
                CustomText(
                  text: 'Your Burger',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.blackColor,
                ),
              ],
            ),
            CustomText(
              text: 'to Your Tastes. Ultimate\n Experience! ',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: AppColors.blackColor,
            ),

            Slider(
              thumbColor: AppColors.primaryColor,
              activeColor: AppColors.primaryColor,
              min: 0,
              max: 1,
              value: widget.initialValue,
              onChanged: widget.onChanged,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(text: '🥶'),
                Gap(120),
                CustomText(text: '🔥'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

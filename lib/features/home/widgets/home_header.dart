import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart'
    show AppColors;
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

Widget buildHomeHeader() {
  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            CustomText(
              text: 'LOQMTK',
              fontSize: 50,
              fontWeight: FontWeight.w800,
              fontFamily: 'Luckiest Guy',
              color: AppColors.primaryColor,
            ),
            CustomText(
              text: 'Delicious food delivery app',
              fontSize: 12,
              color: Color(0xFF98A1B2),
            ),
          ],
        ),
      ),
      const CircleAvatar(
        radius: 40,
        backgroundImage: AssetImage('assets/images/hadi.jpeg'),
      ),
    ],
  );
}

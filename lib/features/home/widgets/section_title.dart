import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

Widget buildSectionTitle(String title, {required VoidCallback onSeeAllTap}) {
  return Row(
    children: <Widget>[
      Expanded(
        child: CustomText(
          text: title,
          color: AppColors.blackColor,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      TextButton(
        onPressed: onSeeAllTap,
        child: const Text(
          'See all',
          style: TextStyle(
            color: Color(0xFFFF5B2E),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}

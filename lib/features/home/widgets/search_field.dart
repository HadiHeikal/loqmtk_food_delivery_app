import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';

Widget buildSearchField() {
  return Material(
    elevation: 10,
    color: AppColors.greyColor,
    borderRadius: BorderRadius.circular(14),
    shadowColor: AppColors.secondaryColor,
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Search food, restaurants...',
        hintStyle: const TextStyle(color: AppColors.greyColor),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.greyColor,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

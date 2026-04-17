import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';

Widget buildPromoCard() {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: <Color>[Color(0xFFFF8A3D), Color(0xFFFF5B2E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              CustomText(
                text: '50% OFF',
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
              Gap(10),
              CustomText(text: 'On your first order', fontSize: 14),
              CustomText(text: 'from selected restaurants', fontSize: 14),
            ],
          ),
        ),
        Gap(20),
        const Icon(
          Icons.local_fire_department_rounded,
          size: 60,
          color: Colors.white,
        ),
      ],
    ),
  );
}

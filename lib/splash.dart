import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(child: Text("Splash Screen")),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/features/auth/views/login_view.dart';
import 'package:loqmtk_food_delivery_app/features/auth/views/signup_view.dart';
import 'package:loqmtk_food_delivery_app/features/home/views/home_view.dart';
import 'package:loqmtk_food_delivery_app/routes/app_routes.dart';
import 'package:loqmtk_food_delivery_app/splash.dart';

class LoqmtkRoot extends StatelessWidget {
  const LoqmtkRoot({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loqmtk Food Delivery App',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/appRoutes': (context) => const AppRoutes(),
        '/login': (context) => const LoginView(),
        '/home': (context) => const HomeView(),
        '/register': (context) => const SignUpView(),
      },
    );
  }
}

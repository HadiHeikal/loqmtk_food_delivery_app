import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/features/auth/views/login_view.dart';
import 'package:loqmtk_food_delivery_app/routes/app_routes.dart';

class LoqmtkRoot extends StatelessWidget {
  const LoqmtkRoot({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loqmtk Food Delivery App',
      initialRoute: '/login',
      routes: {
        '/appRoutes': (context) => const AppRoutes(),
        '/login': (context) => const LoginView(),
      },
    );
  }
}

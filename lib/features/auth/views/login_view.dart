import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/features/auth/widgets/custom_auth_button.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_textform_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey, // Correctly assign _formKey to the Form widget
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(30),
                const CustomText(
                  text: 'LOQMTK',
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gagalin',
                ),
                const CustomText(text: 'Welcome Back to your favorite app'),
                const Gap(30),

                const Gap(30),
                // Email field
                CustomTextformField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  textCapitalization: TextCapitalization.none,
                  isPassword: false,
                ),
                const Gap(20),
                // Password field
                CustomTextformField(
                  controller: _passwordController,
                  hintText: 'Password',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  autofocus: false,
                  textCapitalization: TextCapitalization.none,
                  isPassword: true,
                ),
                const Gap(30),
                // Login button
                CustomAuthButton(
                  onPressed: () {
                    // Handle login logic here
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: CustomText(
                              text: 'Logging in...',
                              color: AppColors.blackColor,
                            ),
                          ),
                          backgroundColor: AppColors.secondaryColor,
                        ),
                      );
                    }
                  },
                  text: 'Login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

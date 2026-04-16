import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/features/auth/widgets/custom_auth_button.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_textform_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
                const CustomText(text: 'Create a new account'),
                const Gap(30),
                // name field
                CustomTextformField(
                  controller: _nameController,
                  hintText: 'Name',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  isPassword: false,
                ),
                const Gap(20),
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
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  textCapitalization: TextCapitalization.none,
                  isPassword: true,
                ),
                const Gap(20),
                // Confirm Password field
                CustomTextformField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  autofocus: false,
                  textCapitalization: TextCapitalization.none,
                  isPassword: true,
                ),
                const Gap(30),
                CustomAuthButton(
                  text: 'Sign Up',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, perform sign up logic here
                      debugPrint('Email: ${_emailController.text}');
                      debugPrint('Password: ${_passwordController.text}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: CustomText(
                              text: 'Signing up...',
                              color: AppColors.blackColor,
                            ),
                          ),
                          backgroundColor: AppColors.secondaryColor,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

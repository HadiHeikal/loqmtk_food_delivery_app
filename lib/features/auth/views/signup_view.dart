import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_error.dart';
import 'package:loqmtk_food_delivery_app/features/auth/data/auth_repo.dart';
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

  bool _isLoading = false;
  final AuthRepository _authRepository = AuthRepository();
  // sign up function
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final user = await _authRepository.register(name, email, password);
      if (user != null && mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      String? errorMessage;
      if (e is ApiError) {
        errorMessage = e.message;
      }
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CustomText(
                text: errorMessage ?? 'An unexpected error occurred.',
                color: AppColors.whiteColor,
              ),
            ),
            backgroundColor: AppColors.redColor,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                _isLoading
                    ? const CircularProgressIndicator(
                        color: AppColors.secondaryColor,
                      )
                    : CustomAuthButton(
                        text: 'Sign Up',
                        onPressed: () => _handleSignUp(),
                      ),
                const Gap(20),
                // Navigate to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(text: 'Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const CustomText(
                        text: 'Login',
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

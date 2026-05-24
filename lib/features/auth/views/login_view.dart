import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_error.dart';
import 'package:loqmtk_food_delivery_app/features/auth/data/auth_repo.dart';
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
  final AuthRepository _authRepository = AuthRepository();

  // variable to track loading state
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final user = await _authRepository.login(email, password);

      if (user != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      String? errorMessage;
      if (e is ApiError) {
        errorMessage = e.message;
      }

      if (mounted) {
        // Show error message in a SnackBar
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(60),
                  const CustomText(
                    text: 'LOQMTK',
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gagalin',
                  ),
                  const CustomText(text: 'Welcome Back to your favorite app'),
                  const Gap(50),

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
                  const Gap(40),

                  // Login button
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.secondaryColor,
                        )
                      : CustomAuthButton(
                          onPressed: _handleLogin,
                          text: 'Login',
                        ),
                  const Gap(20),
                  // Navigate to Signup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(text: "Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const CustomText(
                          text: 'Sign Up',
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
      ),
    );
  }
}

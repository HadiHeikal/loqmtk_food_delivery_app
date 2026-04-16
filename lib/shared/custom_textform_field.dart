import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';

class CustomTextformField extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextformField({
    super.key,
    required this.textInputAction,
    required this.autofocus,
    required this.textCapitalization,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.isPassword,
  });

  @override
  State<CustomTextformField> createState() => _CustomTextformFieldState();
}

class _CustomTextformFieldState extends State<CustomTextformField> {
  late bool _obscureText;
  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorHeight: 24,
      cursorRadius: const Radius.circular(8),
      cursorWidth: 2,
      cursorColor: AppColors.blackColor,
      // Keyboard and text input configuration for email field
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      textCapitalization: widget.textCapitalization,

      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.greyColor,
                ),
                onPressed: togglePasswordVisibility,
              )
            : null,
        hintText: widget.hintText,
        filled: true,
        fillColor: AppColors.whiteColor,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Please enter ${widget.hintText.toLowerCase()}';
        }

        if (widget.isPassword) {
          if (v.length < 6) {
            return 'Password must be at least 6 characters';
          }
        }

        if (widget.keyboardType == TextInputType.emailAddress) {
          if (!v.contains('@')) {
            return 'Please enter a valid email address';
          }
        }

        return null;
      },
      controller: widget.controller,
      obscureText: _obscureText,
    );
  }
}

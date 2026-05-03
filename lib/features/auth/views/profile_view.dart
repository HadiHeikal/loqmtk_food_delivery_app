import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/features/auth/widgets/profile_textfield.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';
import '../../../core/constants/app_colors.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisible = false;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController.text = 'Hadi';
    emailController.text = 'hadi@gmail.com';
    addressController.text = '55 Cairo, Egypt';
    passwordController.text = '••••••••';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(color: AppColors.primaryColor),
        child: Column(
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Profile Picture
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: .3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('assets/images/hadi.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // name Field
            ProfileTextField(
              label: 'Name',
              controller: nameController,
              readOnly: isEditing,
            ),
            const SizedBox(height: 16),
            // email Field
            ProfileTextField(
              label: 'Email',
              controller: emailController,
              readOnly: isEditing,
            ),
            const SizedBox(height: 16),
            // delivery address Field
            ProfileTextField(
              label: 'Delivery address',
              controller: addressController,
              readOnly: isEditing,
            ),
            const SizedBox(height: 16),
            // password Field
            ProfileTextField(
              label: 'Password',
              controller: passwordController,
              isPassword: true,
              readOnly: isEditing,
            ),
            const SizedBox(height: 24),

            const Divider(color: Colors.white54, thickness: 1),
            const SizedBox(height: 24),

            // Visa Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Image.asset('assets/icons/profileVisa.png', width: 60),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debit card',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '3566 **** **** 0505',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  CustomText(
                    text: 'Default',
                    color: AppColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: !isEditing
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save Profile',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.check,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.edit_square,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Log out',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.logout, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

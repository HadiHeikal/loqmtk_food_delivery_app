import 'dart:io'; // Required for File(selectedImagePath!)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for PlatformException safety
import 'package:loqmtk_food_delivery_app/features/auth/data/auth_model.dart';
import 'package:loqmtk_food_delivery_app/features/auth/data/auth_repo.dart';
import 'package:loqmtk_food_delivery_app/features/auth/widgets/profile_textfield.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Text Editing Controllers for Profile Form Fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController visaController = TextEditingController();

  // Component UI State Management Flaggers
  bool isVisible = false;
  bool isEditing = false; // Toggles between view-only mode and form-edit mode
  bool _isHovered = false; // Tracks mouse hover exclusively during edit mode
  bool _isLoading =
      false; // Critical guard to block multiple overlapping API/Platform requests
  String?
  selectedImagePath; // Stores local cache path of newly picked image file

  final AuthRepository _authRepository = AuthRepository();
  UserModel? userModel;

  /// Fetches the user profile data from the secure API repository architecture
  Future<void> _loadUserProfile() async {
    try {
      final user = await _authRepository.getProfile();
      if (user != null) {
        setState(() {
          userModel = user;
          // Synchronize text controllers with updated backend model datasets
          nameController.text = user.name;
          emailController.text = user.email;
          addressController.text = user.address ?? '';
          visaController.text = user.visa ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
      }
    }
  }

  /// Triggers the mobile native system gallery infrastructure using ImagePicker
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
        setState(() {
          selectedImagePath = pickedImage.path;
        });
      }
    } on PlatformException catch (e) {
      // Safely intercepts hung instances, already_active errors, or system channel rejections
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gallery connection error: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error picking image: $e')),
        );
      }
    }
  }

  /// Packages form values into Multipart FormData chunks and updates the server database
  Future<void> _updateProfile() async {
    if (_isLoading) return; // Prevent double taps or execution overlap

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authRepository.editProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
        imagePath: selectedImagePath,
        visa: visaController.text.trim().toString(),
      );

      if (user != null) {
        setState(() {
          userModel = user;
          isEditing =
              false; // Gracefully exit edit mode upon validation success
          selectedImagePath = null; // Flush local file preview cache pipeline
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading =
              false; // Always discharge loading lock state inside finalization phase
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    // Native lifecycle cleanup: resolves and flushes any hung image picker channel intents on Android
    ImagePicker().retrieveLostData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    visaController.dispose();
    super.dispose();
  }

  /// Evaluates and yields appropriate ImageProvider based on state availability
  ImageProvider _getProfileImage() {
    if (selectedImagePath != null && selectedImagePath!.isNotEmpty) {
      return FileImage(File(selectedImagePath!));
    }
    if (userModel?.image != null && userModel!.image!.isNotEmpty) {
      return NetworkImage(userModel!.image!);
    }
    return const AssetImage('assets/images/hadi.jpeg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUserProfile,
          color: AppColors.primaryColor,
          backgroundColor: AppColors.whiteColor,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(color: AppColors.primaryColor),
                      child: Skeletonizer(
                        enabled: userModel == null,
                        child: Column(
                          children: [
                            // --------------------------- Navigation Action Row ---------------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // --------------------------- Profile Picture (Interactive Engine) ---------------------------
                            MouseRegion(
                              cursor: (isEditing && !_isLoading)
                                  ? SystemMouseCursors.click
                                  : SystemMouseCursors.basic,
                              onEnter: (_) => setState(
                                () => _isHovered = isEditing,
                              ), // Limit hover visual triggers exclusively to edit mode
                              onExit: (_) => setState(() => _isHovered = false),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: (isEditing && !_isLoading)
                                    ? _pickImage
                                    : null, // Disable interactive selection unless edit mode is true
                                child: SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: Stack(
                                    children: [
                                      // Base Layer Component: Profile Avatar Rendering Structure
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withValues(
                                                alpha: .3,
                                              ),
                                              blurRadius: 20,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: _getProfileImage(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                      // Secondary Layer Component: Animated Indicator Overlay
                                      AnimatedOpacity(
                                        opacity: _isHovered ? 1.0 : 0.0,
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            color: Colors.black.withValues(
                                              alpha: .5,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.edit_rounded,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // --------------------------- Form Fields Text Input Layout ---------------------------
                            ProfileTextField(
                              label: 'Name',
                              controller: nameController,
                              readOnly:
                                  !isEditing, // Input lock condition: editable exclusively when isEditing is active
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Email',
                              controller: emailController,
                              readOnly: !isEditing,
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Delivery address',
                              controller: addressController,
                              readOnly: !isEditing,
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Password',
                              controller: passwordController,
                              isPassword: true,
                              readOnly: !isEditing,
                            ),
                            const SizedBox(height: 24),

                            const Divider(color: Colors.white54, thickness: 1),
                            const SizedBox(height: 24),

                            // --------------------------- Visa Dynamic Validation Frame ---------------------------
                            userModel?.visa != null &&
                                    userModel!.visa!.isNotEmpty &&
                                    !isEditing
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/profileVisa.png',
                                          width: 60,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Debit card',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                userModel?.visa ??
                                                    '**** **** **** 0505',
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12,
                                                ),
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
                                  )
                                : ProfileTextField(
                                    isPassword: false,
                                    readOnly: !isEditing,
                                    keyboardType: TextInputType.number,
                                    label: 'Add Visa Card Number',
                                    controller: visaController,
                                  ),
                            const Spacer(),

                            // --------------------------- Bottom Operational Control Row ---------------------------
                            Row(
                              children: [
                                // Dynamic Primary Trigger Button (Handles Form Toggling and API Syncing)
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _isLoading
                                        ? null // Block interaction while loading indicator is processing requests
                                        : () {
                                            if (isEditing) {
                                              _updateProfile(); // Submit structural modifications to core DB
                                            } else {
                                              setState(() {
                                                isEditing =
                                                    true; // Transition structural layout context into active edit mode
                                              });
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Color(0xFF212121),
                                                  ),
                                            ),
                                          )
                                        : isEditing
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Save Profile',
                                                style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                Icons.check,
                                                color: AppColors.primaryColor,
                                                size: 20,
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Edit Profile',
                                                style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
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

                                // Secondary Action Control Button (Log out Anchor Framework)
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () {}, // Guarded against state updates
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Log out',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.logout,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
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
            },
          ),
        ),
      ),
    );
  }
}

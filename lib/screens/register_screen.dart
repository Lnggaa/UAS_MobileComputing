import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _photoPath;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) setState(() => _photoPath = picked.path);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    final error = await auth.register(
      name: _nameController.text,
      password: _passwordController.text,
      photoPath: _photoPath,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
      return;
    }

    // Sukses → ke onboarding
    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.flight_takeoff_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Create Account',
                        style: AppTextStyles.displayMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Start your travel journey today',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Photo picker
                Center(
                  child: GestureDetector(
                    onTap: _pickPhoto,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          backgroundImage: _buildPhotoImage(),
                          child: _photoPath == null
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 48,
                                  color: AppColors.primary.withValues(
                                    alpha: 0.5,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Tap to add profile photo',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Name
                Text('Username', style: AppTextStyles.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.textMuted,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Name is required';
                    if (v.trim().length < 3) return 'Min 3 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password
                Text('Password', style: AppTextStyles.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Min 6 characters',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.textMuted,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'Min 6 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Confirm password
                Text('Confirm Password', style: AppTextStyles.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Repeat your password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.textMuted,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) {
                    if (v != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Register button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Create Account'),
                  ),
                ),

                const SizedBox(height: 16),

                // Go to login
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyles.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: Text(
                          'Login',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider? _buildPhotoImage() {
    if (_photoPath == null) return null;
    if (kIsWeb) return NetworkImage(_photoPath!);
    return FileImage(File(_photoPath!));
  }
}

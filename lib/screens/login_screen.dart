import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    final error = await auth.login(
      name: _nameController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
      return;
    }

    // Cek apakah sudah lihat onboarding
    final user = auth.currentUser;
    if (user != null && !user.hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
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
                const SizedBox(height: 60),

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
                      Text('Welcome Back!', style: AppTextStyles.displayMedium),
                      const SizedBox(height: 6),
                      Text(
                        'Login to continue your journey',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Username
                Text('Username', style: AppTextStyles.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'Enter your username',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.textMuted,
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Username is required' : null,
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
                    hintText: 'Enter your password',
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
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Password is required' : null,
                ),

                const SizedBox(height: 32),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),

                const SizedBox(height: 16),

                // Go to register
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyles.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/register',
                        ),
                        child: Text(
                          'Register',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

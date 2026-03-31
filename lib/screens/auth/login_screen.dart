import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../provider/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
    });
    try {
      await ref
          .read(authProvider.notifier)
          .login(phoneController.text, passwordController.text);
      final user = ref.read(authProvider);
      if (user != null && user.employeeId != null) {
        await ref.read(profileProvider.notifier).fetchProfile(user.employeeId!);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setInt('employee_id', user.employeeId!);
        if (mounted) {
          context.go('/dashboard');
        }
      } else {
        throw Exception('Invalid user data');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed! Please check your credentials.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kBlack.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: kBrown.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isPassword ? TextInputType.text : TextInputType.phone,
        style: kBodyTextStyle.copyWith(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: kBrown.withOpacity(0.7)),
          hintText: hintText,
          hintStyle: kBodyTextStyle.copyWith(color: kGrey),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          filled: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteGrey,
      body: Stack(
        children: [
          // Subtle background decoration
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGreen.withOpacity(0.08),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
              child: Container(color: Colors.transparent),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    // Premium Header Section
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: kBlack.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/logo/A24.png',
                        width: 48,
                        height: 48,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Welcome\nBack!',
                      style: kHeaderTextStyle.copyWith(
                        fontSize: 42,
                        height: 1.1,
                        color: kBlack,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sign in to access your activity hub and \nmanage your attendance.',
                      style: kBodyTextStyle.copyWith(
                        color: kBrown.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Form Section
                    _buildTextField(
                      controller: phoneController,
                      hintText: 'Phone Number',
                      icon: Iconsax.call,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      icon: Iconsax.lock,
                      isPassword: true,
                    ),
                    const SizedBox(height: 6),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(foregroundColor: kBrown),
                        child: Text(
                          'Forgot Password?',
                          style: kCaptionTextStyle.copyWith(
                            color: kBrown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Login Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: kGreen.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kGreen,
                          foregroundColor: kWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: isLoading ? null : handleLogin,
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: kWhite,
                                ),
                              )
                            : Text(
                                'Login',
                                style: kHeaderTextStyle.copyWith(
                                  fontSize: 18,
                                  color: kWhite,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: kGreen, thickness: 2),
                    const SizedBox(height: 12),
                    // Login as Admin Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login as an",
                          style: kBodyTextStyle.copyWith(color: kGrey),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            " Admin",
                            style: kBodyTextStyle.copyWith(
                              color: kBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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

  static Uri get _adminPortalUri =>
      Uri.parse('https://adminattendx.naiyo24.com/#/splash');

  static const String _demoPhoneNumber = '6289398298';
  static const String _demoPassword = '12345678';

  late final TapGestureRecognizer _demoTapRecognizer;

  @override
  void initState() {
    super.initState();
    _demoTapRecognizer = TapGestureRecognizer()..onTap = _showDemoBottomSheet;
  }

  @override
  void dispose() {
    _demoTapRecognizer.dispose();
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

  Future<void> _openAdminPortal() async {
    try {
      final uri = _adminPortalUri;
      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open admin portal.')),
          );
        }
        return;
      }

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open admin portal.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open admin portal.')),
        );
      }
    }
  }

  Future<void> _copyToClipboard(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard.')));
  }

  void _showDemoBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: kBlack.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Demo Login',
                style: kHeaderTextStyle.copyWith(fontSize: 20, color: kBlack),
              ),
              const SizedBox(height: 6),
              Text(
                'Use these credentials to explore the app.',
                style: kBodyTextStyle.copyWith(color: kBrown.withOpacity(0.7)),
              ),
              const SizedBox(height: 18),
              _demoCredentialTile(
                label: 'Phone Number',
                value: _demoPhoneNumber,
                onCopy: () => _copyToClipboard(_demoPhoneNumber),
              ),
              const SizedBox(height: 12),
              _demoCredentialTile(
                label: 'Password',
                value: _demoPassword,
                onCopy: () => _copyToClipboard(_demoPassword),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: kBlack.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Forgot Password?',
                style: kHeaderTextStyle.copyWith(fontSize: 20, color: kerror),
              ),
              const SizedBox(height: 8),
              Text(
                'Please contact your organizational admin to reset your password.',
                style: kBodyTextStyle.copyWith(
                  color: kBrown.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _demoCredentialTile({
    required String label,
    required String value,
    required VoidCallback onCopy,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: kCaptionTextStyle.copyWith(
                    color: kBrown.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: kBodyTextStyle.copyWith(
                    color: kBlack,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCopy,
            icon: const Icon(Icons.copy_rounded),
            color: kBrown,
            tooltip: 'Copy',
          ),
        ],
      ),
    );
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
                        onPressed: _showForgotPasswordBottomSheet,
                        style: TextButton.styleFrom(foregroundColor: kBrown),
                        child: Text(
                          'Forgot Password?',
                          style: kCaptionTextStyle.copyWith(
                            color: kerror,
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
                                  fontSize: 22,
                                  color: kWhite,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: kBlack, thickness: 1),
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
                          onTap: _openAdminPortal,
                          child: Text(
                            " Organization Admin",
                            style: kBodyTextStyle.copyWith(
                              color: kBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          style: kCaptionTextStyle.copyWith(color: kGrey),
                          children: [
                            const TextSpan(text: 'Need a demo? '),
                            TextSpan(
                              text: 'Get a Demo',
                              recognizer: _demoTapRecognizer,
                              style: kCaptionTextStyle.copyWith(
                                color: kGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
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

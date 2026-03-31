import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/profile_provider.dart';
import '../../provider/attendance_provider.dart';
import '../../provider/holiday_provider.dart';
import '../../theme/app_theme.dart';
import '../../services/force_update_services.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _nameFade;
  late Animation<Offset> _nameSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _nameFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeIn),
      ),
    );
    _nameSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
          ),
        );
    _controller.forward();
    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    
    // Check for App Updates first
    final updateService = ForceUpdateService();
    final updateResult = await updateService.checkForUpdate();
    if (!mounted) return;
    
    if (updateResult['hasUpdate'] == true) {
      context.go('/force-update', extra: {
        'apkUrl': updateResult['apkUrl'],
        'latestVersion': updateResult['latestVersion'],
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    if (!mounted) return;
    if (isLoggedIn) {
      final employeeId = prefs.getInt('employee_id');
      if (employeeId != null) {
        await ref.read(profileProvider.notifier).fetchProfile(employeeId);
        await ref
            .read(attendanceProvider.notifier)
            .fetchAttendanceByEmployee(employeeId);
      }
      final user = ref.read(profileProvider);
      final adminId = user?.adminId;
      if (adminId != null) {
        await ref.read(holidayProvider.notifier).fetchHolidaysByAdmin(adminId);
      }
      if (!mounted) return;
      context.go('/dashboard');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteGrey,
      body: Stack(
        children: [
          // Decorative Background Gradient Orbs
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGreen.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kBrown.withOpacity(0.08),
              ),
            ),
          ),
          // Glassmorphism Blur Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Transform.scale(
                    scale: _logoScale.value,
                    child: Opacity(
                      opacity: _logoFade.value,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kWhite,
                          boxShadow: [
                            BoxShadow(
                              color: kGreen.withOpacity(0.25),
                              blurRadius: 50,
                              offset: const Offset(0, 15),
                            ),
                            BoxShadow(
                              color: kBlack.withOpacity(0.05),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Image.asset(
                            'assets/logo/A24.png',
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Opacity(
                    opacity: _nameFade.value,
                    child: SlideTransition(position: _nameSlide, child: child!),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Attendx24',
                        style: kHeaderTextStyle.copyWith(
                          color: kBlack,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Powered by Naiyo24',
                        style: kTaglineTextStyle.copyWith(
                          color: kBrown.withOpacity(0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../cards/dashboard/quit_app_bottomsheet.dart';
import '../../provider/dashboard_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../cards/dashboard/welcome_card.dart';
import '../../provider/profile_provider.dart';
import '../../cards/dashboard/check_in_out_card.dart';
import '../../cards/dashboard/break_time_card.dart'; // Added BreakTimeCard Import
import '../../provider/break_time_provider.dart'; // Added BreakTimeProvider Import
import '../../widgets/loader.dart';
import '../../cards/dashboard/feature_card.dart';
import '../../cards/dashboard/footer_card.dart';
import '../../theme/app_theme.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    setState(() => _isLoading = true);
    final user = ref.read(profileProvider);
    if (user?.employeeId != null) {
      await Future.wait([
        ref
            .read(dashboardProvider.notifier)
            .fetchLatestAttendance(user!.employeeId!),
        ref.read(breakTimeProvider.notifier).fetchAllBreaks(user.employeeId!),
      ]);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    final router = GoRouter.of(context);
    switch (index) {
      case 0:
        break;
      case 1:
        router.go('/my-attendance');
        break;
      case 2:
        router.go('/holidays');
        break;
      case 3:
        router.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        final shouldExit = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const QuitAppBottomSheet(),
        );
        if (shouldExit == true) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: kWhiteGrey,
            appBar: const PremiumAppBar(
              title: 'Dashboard',
              subtitle: 'Record your attendance easily',
              logoAssetPath: 'assets/logo/A24.png',
              showBackIcon: false,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeCard(userName: user?.fullName ?? 'User'),
                  const SizedBox(height: 16),
                  CheckInOutCard(
                    onLoading: (loading) {
                      if (mounted) setState(() => _isLoading = loading);
                    },
                    onRefresh: _fetchAttendance,
                  ),
                  const SizedBox(height: 16),
                  BreakTimeCard(
                    onLoading: (loading) {
                      if (mounted) setState(() => _isLoading = loading);
                    },
                  ),
                  const SizedBox(height: 16),
                  const FeatureCard(),
                  const SizedBox(height: 24),
                  const HomeFooter(),
                  const SizedBox(height: 48), // Padding before BottomNavBar
                ],
              ),
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
            ),
          ),
          if (_isLoading) const AppLoader(subText: 'Syncing attendance...'),
        ],
      ),
    );
  }
}

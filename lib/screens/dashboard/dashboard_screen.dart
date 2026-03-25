import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../provider/dashboard_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../cards/dashboard/welcome_card.dart';
import '../../provider/profile_provider.dart';
import '../../cards/dashboard/check_in_out_card.dart';
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
			await ref.read(dashboardProvider.notifier).fetchLatestAttendance(user!.employeeId!);
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
				router.go('/dashboard');
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
		return Stack(
			children: [
				Scaffold(
					backgroundColor: kWhite,
					appBar: const PremiumAppBar(
						title: 'Dashboard',
						subtitle: 'Record your attendance easily',
						logoAssetPath: 'assets/logo/attendx24_logo.jpeg',
					),
					body: SingleChildScrollView(
						padding: const EdgeInsets.all(kScreenPadding),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								WelcomeCard(userName: user?.fullName ?? 'User', cardColor: kWhite),
								CheckInOutCard(
									cardColor: kWhite,
									onLoading: (loading) {
										if (mounted) setState(() => _isLoading = loading);
									},
									onRefresh: _fetchAttendance,
								),
								const FeatureCard(cardColor: kWhite),
								const SizedBox(height: 16),
								const HomeFooter(),
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
		);
	}
}

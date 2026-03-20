import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../cards/dashboard/welcome_card.dart';
import '../../cards/dashboard/check_in_out_card.dart';
import '../../cards/dashboard/feature_card.dart';
import '../../cards/dashboard/footer_card.dart';
import '../../theme/app_theme.dart';

class DashboardScreen extends ConsumerStatefulWidget {
	const DashboardScreen({super.key});

	@override
	ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
	int _currentIndex = 0;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: kWhite,
			appBar: const DashboardAppBar(
				title: 'Attendance Dashboard',
				subtitle: 'Record your attendance easily',
			),
			body: SingleChildScrollView(
				padding: const EdgeInsets.all(kScreenPadding),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						WelcomeCard(userName: 'User', cardColor: kWhite),
						const CheckInOutCard(cardColor: kWhite),
						const FeatureCard(cardColor: kWhite),
						const SizedBox(height: 16),
						const HomeFooter(),
					],
				),
			),
			bottomNavigationBar: BottomNavBar(
				currentIndex: _currentIndex,
				onTap: (index) {
					setState(() {
						_currentIndex = index;
						// TODO: Implement navigation for other tabs
					});
				},
			),
		);
	}
}

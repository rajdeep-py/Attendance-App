import 'package:attendance_app/cards/dashboard/footer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../cards/profile/profile_header_card.dart';
import '../../cards/profile/profile_options_card.dart';
import '../../provider/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);
    return Scaffold(
          appBar: const PremiumAppBar(
            title: 'Profile',
            subtitle: 'View and manage your account',
            logoAssetPath: 'assets/logo/logo_no_bg.png',
            showBackIcon: false,
          ),
      backgroundColor: kWhiteGrey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            const SizedBox(height: 16),
            ProfileHeaderCard(user: user),
            const SizedBox(height: 2),
            const ProfileOptionsCard(),
            const SizedBox(height: 2),
            const HomeFooter()
          ],
        ),
      ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: 3,
            onTap: (index) {
              // Add navigation logic if needed
            },
          ),
    );
  }
}

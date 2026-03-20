import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class ProfileOptionsCard extends StatelessWidget {
  const ProfileOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      {
        'icon': Iconsax.edit,
        'title': 'Update Profile',
        'subtitle': 'Edit your personal information',
      },
      {
        'icon': Iconsax.document,
        'title': 'Download Salary Slip',
        'subtitle': 'Get your monthly salary slip',
      },
      {
        'icon': Iconsax.notification,
        'title': 'Notifications',
        'subtitle': 'Manage notification preferences',
      },
      {
        'icon': Iconsax.info_circle,
        'title': 'About Us',
        'subtitle': 'Learn more about the company',
      },
      {
        'icon': Iconsax.message,
        'title': 'Help Center',
        'subtitle': 'Get support and assistance',
      },
      {
        'icon': Iconsax.logout,
        'title': 'Log Out',
        'subtitle': 'Sign out of your account',
      },
    ];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kDarkGrey.withAlpha((0.08 * 255).toInt()),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        color: kWhite,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (_, _) => const Divider(height: 1, color: kWhiteGrey),
        itemBuilder: (context, index) {
          final option = options[index];
          return ListTile(
            leading: Container(
              decoration: BoxDecoration(
                color: kWhiteGrey,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(option['icon'] as IconData, color: kDarkGrey, size: 24),
            ),
            title: Text(option['title'] as String, style: TextStyle(color: kBlack, fontWeight: FontWeight.w600)),
            subtitle: Text(option['subtitle'] as String, style: TextStyle(color: kGrey)),
            onTap: () {},
          );
        },
      ),
    );
  }
}
